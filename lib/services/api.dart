import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nebula_id/auth/auth.dart';
import 'package:nebula_id/model/nebula.dart';
import 'package:nebula_id/model/service.dart';
import 'package:nebula_id/nebula_id.dart';

class ApiService implements Service {
  Dio dio = new Dio();
  Access _access;
  Auth _auth;

  ApiService() {
    _access = NebulaId.access;
    _auth = NebulaId.auth;
    dio.options.baseUrl = 'http://18.219.30.186:3020/v1/${_auth.company}/';
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
      queryParameters: {'uuid': _access.uuid},
      options: Options(
        headers: await _auth.buildHeaders(),
      ),
    );
    return checkResponse(response);
  }

  @override
  Future<Map> validFace(Map data) async {
    Response response = await dio.post(
      'facial_id_verify',
      data: jsonEncode(data),
      queryParameters: {'uuid': _access.uuid},
      options: Options(
        headers: await _auth.buildHeaders(),
      ),
    );
    return checkResponse(response);
  }

  @override
  Future<String> createUser() async {
    Response response = await dio.get(
      'user',
      options: Options(
        headers: await _auth.buildHeaders(),
      ),
    );
    return checkResponse(response)['uuid'];
  }

  @override
  Future<String> getToken() async {
    Response response = await dio.get(
      'public',
      queryParameters: {
        'user': _auth.user,
        'secret': _auth.secret,
      },
    );
    return checkResponse(response)['access'];
  }

  @override
  saveCountry(Map data) async {
    Response response = await dio.post(
      'country',
      data: jsonEncode(data),
      queryParameters: {'uuid': _access.uuid},
      options: Options(
        headers: await _auth.buildHeaders(),
      ),
    );
    return checkResponse(response);
  }

  @override
  analiseDocument(Map data) async {
    Response response = await dio.post(
      'document',
      data: jsonEncode(data),
      queryParameters: {'uuid': _access.uuid},
      options: Options(
        headers: await _auth.buildHeaders(),
      ),
    );
    return checkResponse(response);
  }

  @override
  Future<Map> getDocument() async {
    Response response = await dio.get(
      'data',
      queryParameters: {'uuid': _access.uuid},
      options: Options(headers: await _auth.buildHeaders()),
    );
    return checkResponse(response);
  }
}
