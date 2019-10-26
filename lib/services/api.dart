import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nebula_id/auth/auth.dart';
import 'package:nebula_id/model/service.dart';

class ApiService implements Service {
  Dio dio = new Dio();
  final Auth auth;

  ApiService({this.auth}) {
    dio.options.baseUrl = 'https://www.craftinglbs.com/';
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
    Response response = await dio.post(
      'facial_id',
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
      options: Options(
        headers: await auth.buildHeaders(),
      ),
    );
    return checkResponse(response);
  }
}