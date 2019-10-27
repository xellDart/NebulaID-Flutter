import 'package:dio/dio.dart';
import 'package:nebula_id/services/api.dart';

abstract class APIResult {
  void onResult(dynamic value);

  void onError(DioError err);
}

class ApiPresenter {
  APIResult result;
  ApiService service;
  Map<String, dynamic> data;

  ApiPresenter.user(this.result) {
    service = new ApiService();
  }

  ApiPresenter.face(this.result, this.data) {
    service = new ApiService();
  }

  ApiPresenter.country(this.result, this.data) {
    service = new ApiService();
  }

  ApiPresenter.document(this.result, this.data) {
    service = new ApiService();
  }

  void createUser() {
    assert(result != null);
    service
        .createUser()
        .then((response) => result.onResult(response))
        .catchError((onError) {
      result.onError(onError);
    });
  }

  void getToken() {
    assert(result != null);
    service
        .getToken()
        .then((response) => result.onResult(response))
        .catchError((onError) {
      result.onError(onError);
    });
  }

  void saveFace() {
    assert(result != null);
    service
        .saveFace(data)
        .then((response) => result.onResult(response))
        .catchError((onError) {
      result.onError(onError);
    });
  }

  void validFace() {
    assert(result != null);
    service
        .validFace(data)
        .then((response) => result.onResult(response))
        .catchError((onError) {
      result.onError(onError);
    });
  }

  void setCountry() {
    assert(result != null);
    service
        .saveCountry(data)
        .then((response) => result.onResult(response))
        .catchError((onError) {
      result.onError(onError);
    });
  }

  void analiseDocument() {
    assert(result != null);
    service
        .analiseDocument(data)
        .then(() => result.onResult('analise'))
        .catchError((onError) {
      result.onError(onError);
    });
  }

  void getDocument() {
    assert(result != null);
    service
        .getDocument()
        .then((response) => result.onResult(response))
        .catchError((onError) {
      result.onError(onError);
    });
  }
}
