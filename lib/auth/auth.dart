import 'package:dio/dio.dart';
import 'package:nebula_id/presenter/presenter.dart';
import 'package:nebula_id/user/user.dart';
import 'package:nebula_id/utils/storage.dart';

class Auth implements APIResult {
  User data = User();
  final String company;
  final String encrypt;
  final String secret;
  final String user;
  final OnStart start;

  static String token;

  Auth({this.company, this.encrypt, this.secret, this.user, this.start});

  setToken() => ApiPresenter.user(this).getToken();

  Future<Map<String, String>> buildHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'integrity': encrypt
    };
  }

  Future<String> getUUID() async {
    return await Storage().getString('uuid_nebula');
  }

  _checkUser() async {
    bool has = await data.hasUser();
    if(!has) data.createUser();
    start();
  }

  @override
  void onError(DioError err) {
    print(err.message);
  }

  @override
  void onResult(value) {
    token = value;
    _checkUser();
  }
}
