import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nebula_id/auth/auth.dart';
import 'package:nebula_id/model/nebula.dart';
import 'package:nebula_id/model/service.dart';
import 'package:nebula_id/nebula_id.dart';
import 'package:retry/retry.dart';

class ApiService implements Service {
  Dio dio = new Dio();
  Access _access;
  Auth _auth;

  ApiService() {
    _access = NebulaId.access;
    _auth = NebulaId.auth;
    dio.options.baseUrl = 'http://18.219.30.186:3020/v1/${_auth.company}/';
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
    final Response response = await retry(
      () async => dio.get(
      'public',
      queryParameters: {
        'user': _auth.user,
        'secret': _auth.secret,
      },
    ).timeout(Duration(seconds: 5)),
      retryIf: (e) => e is TimeoutException,
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
    final Response response = await retry(
      () async => dio.get(
      'data',
      queryParameters: {'uuid': _access.uuid},
      options: Options(headers: await _auth.buildHeaders()),
    ).timeout(Duration(seconds: 5)),
      retryIf: (e) => e is TimeoutException,
    );
    return checkResponse(response);
  }
}
