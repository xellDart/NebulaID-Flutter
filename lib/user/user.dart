import 'package:dio/dio.dart';
import 'package:nebula_id/presenter/presenter.dart';
import 'package:nebula_id/utils/storage.dart';

class User implements APIResult {

  User() {
    ApiPresenter.user(this).createUser();
  }

  @override
  void onError(DioError err) {
    print(err.message);
  }

  @override
  void onResult(value) {
    print(value);
    Storage().saveString('uuid_nebula', value as String);
  }
}
