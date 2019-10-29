import 'package:dio/dio.dart';
import 'package:nebula_id/model/nebula.dart';
import 'package:nebula_id/presenter/presenter.dart';
import 'package:nebula_id/utils/storage.dart';

typedef OnUUID(String uuid);

class User implements APIResult {
  Nebula onUUID;
  Storage storage = new Storage();

  User(this.onUUID);

  createUser() => ApiPresenter.user(this).createUser();

  @override
  void onError(DioError err) => onUUID.onResult(err.message);

  @override
  void onResult(value) => onUUID.onUUID(value.toString());
}
