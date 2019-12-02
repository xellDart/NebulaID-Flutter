import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nebula_id/auth/auth.dart';
import 'package:nebula_id/model/nebula.dart';
import 'package:nebula_id/model/service.dart';
import 'package:nebula_id/nebula_id.dart';
import 'package:nebula_id/utils/retry/dio_retry.dart';

class ApiService implements Service {
  Dio dio = new Dio();
  Access _access;
  Auth _auth;

  ApiService() {
    _access = NebulaId.access;
    _auth = NebulaId.auth;
    dio.options.baseUrl = 'http://18.219.30.186:3020/v1/${_auth.company}/';
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      options: RetryOptions(
        retries: 3,
        retryInterval: const Duration(seconds: 5),
      ),
    ));
  }

  @override
  saveFace(Map data) async {
    Response response = await dio.post('facial_id', data: data, queryParameters: {'uuid': _access.uuid},
        options: Options(
          headers: await _auth.buildHeaders(),
        ));
    return response.data;
  }

  @override
  Future<Map> validFace(Map data) async {
    Response response = await dio.post('facial_id_verify', data: data, queryParameters: {'uuid': _access.uuid},
        options: Options(
          headers: await _auth.buildHeaders(),
        ));
    return response.data;
  }

  @override
  Future<String> createUser() async {
    Response response = await dio.get('user', queryParameters: {'uuid': _access.uuid},
        options: Options(
          headers: await _auth.buildHeaders(),
        ));
    return response.data['uuid'];
  }

  @override
  Future<String> getToken() async {
    Response response = await dio.get('public', queryParameters: {
      'user': _auth.user,
      'secret': _auth.secret,
    });
    return response.data['access'];
  }

  @override
  saveCountry(Map data) async {
    Response response = await dio.post('country', data: data, queryParameters: {'uuid': _access.uuid},
        options: Options(
          headers: await _auth.buildHeaders(),
        ));
    return response.data;
  }

  @override
  analiseDocument(Map data) async {
    Response response = await dio.post('document', data: data, queryParameters: {'uuid': _access.uuid},
        options: Options(
          headers: await _auth.buildHeaders(),
        ));
    return response.data;
  }

  @override
  Future<Map> getDocument() async {
    Response response = await dio.get('data', queryParameters: {'uuid': _access.uuid},
        options: Options(
          headers: await _auth.buildHeaders(),
        ));
    return response.data;
  }
}
