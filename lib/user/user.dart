import 'package:dio/dio.dart';
import 'package:nebula_id/presenter/presenter.dart';
import 'package:nebula_id/utils/storage.dart';

class User implements APIResult {
  Storage storage = new Storage();

  createUser() {
    ApiPresenter.user(this).createUser();
  }

  Future<bool> hasUser() async {
    return await storage.getString('uuid_nebula') != null;
  }

  @override
  void onError(DioError err) {
    print(err.message);
  }

  @override
  void onResult(value) {
    print(value);
    storage.saveString('uuid_nebula', value as String);
  }
}
