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

  ApiPresenter.face(this.result, this.data) {
    service = new ApiService();
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
}
