import 'package:dio/dio.dart';
import 'package:nebula_id/presenter/presenter.dart';

typedef OnUser(String result);

class User implements APIResult {

  final OnUser result;

  User({this.result}) {
    ApiPresenter.user(this).createUser();
  }

  @override
  void onError(DioError err) {
    result(err.message);
  }

  @override
  void onResult(value) {
    result(value as String);
  }
}
