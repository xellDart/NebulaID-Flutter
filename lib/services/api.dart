import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nebula_id/auth/auth.dart';
import 'package:nebula_id/model/service.dart';
import 'package:nebula_id/nebula_id.dart';

class ApiService implements Service {
  Dio dio = new Dio();
  Auth auth;

  ApiService() {
    auth = NebulaId.auth;
    dio.options.baseUrl = 'http://192.168.0.8:3020/v1/${auth.company}/';
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  dynamic checkResponse(response) {
    return response.data;
  }

  @override
  saveFace(Map data) async {
    print(await auth.getUUID());
    Response response = await dio.post(
      'facial_id/${await auth.getUUID()}',
      data: jsonEncode(data),
      options: Options(
        headers: await auth.buildHeaders(),
      ),
    );
    return checkResponse(response);
  }

  @override
  Future<Map> validFace(Map data) async {
    Response response = await dio.post(
      'facial_id_verify',
      data: jsonEncode(data),
      queryParameters: {'uuid': await auth.getUUID()},
      options: Options(
        headers: await auth.buildHeaders(),
      ),
    );
    return checkResponse(response);
  }

  @override
  Future<String> createUser() async {
    Response response = await dio.get(
      'user',
      options: Options(
        headers: await auth.buildHeaders(),
      ),
    );
    return checkResponse(response)['uuid'];
  }

  @override
  Future<String> getToken() async {
    Response response = await dio.get(
      'public',
      queryParameters: {
        'user': auth.user,
        'secret': auth.secret,
      },
    );
    return checkResponse(response)['access'];
  }
}
