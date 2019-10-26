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

  static String token;

  Auth({this.company, this.encrypt, this.secret, this.user});

  setToken() => ApiPresenter.user(this).getToken();

  Future<Map<String, String>> buildHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorizathion': 'Bearer $token',
      'Integration': encrypt
    };
  }

  Future<String> getUUID() {
    return Storage().getString('uuid_nebula');
  }

  _checkUser() async {
    if(await data.hasUser())  data.createUser();
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
