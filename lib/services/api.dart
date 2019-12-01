import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<dynamic> _get({@required String method, Map query}) async {
    Response response = await dio.get(method,
        queryParameters: query,
        options: Options(
          headers: await _auth.buildHeaders(),
        ));
    return response.data;
  }

  Future<dynamic> _post(
      {@required String method, @required Map data, Map query}) async {
    Response response = await dio.post(method,
        queryParameters: query,
        data: jsonEncode(data),
        options: Options(
          headers: await _auth.buildHeaders(),
        ));
    return response.data;
  }

  @override
  saveFace(Map data) async => await _post(
      method: 'facial_id', data: data, query: {'uuid': _access.uuid});

  @override
  Future<Map> validFace(Map data) async => await _post(
      method: 'facial_id_verify', data: data, query: {'uuid': _access.uuid});

  @override
  Future<String> createUser() async => (await _get(method: 'user'))['uuid'];

  @override
  Future<String> getToken() async => (await _get(method: 'public', query: {
        'user': _auth.user,
        'secret': _auth.secret,
      }))['access'];

  @override
  saveCountry(Map data) async =>
      await _post(method: 'country', data: data, query: {'uuid': _access.uuid});

  @override
  analiseDocument(Map data) async => await _post(
      method: 'document', data: data, query: {'uuid': _access.uuid});

  @override
  Future<Map> getDocument() async =>
      _get(method: 'data', query: {'uuid': _access.uuid});
}
