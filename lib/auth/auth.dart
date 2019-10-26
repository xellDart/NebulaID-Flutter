import 'package:dio/dio.dart';
import 'package:nebula_id/presenter/presenter.dart';

class Auth implements APIResult {
  final String company;
  final String encrypt;
  final String secret;
  final String user;

  static String token;

  Auth({this.company, this.encrypt, this.secret, this.user}) {
    ApiPresenter.user(this).getToken();
  }

  String getCompany() {
    return this.company;
  }

  Future<Map<String, String>> buildHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorizathion': 'Bearer $token',
      'Integration': encrypt
    };
  }

  @override
  void onError(DioError err) {
    print(err.message);
  }

  @override
  void onResult(value) {
    print(value);
    token = value;
  }
}
