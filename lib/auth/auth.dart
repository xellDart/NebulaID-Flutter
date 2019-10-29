import 'package:dio/dio.dart';
import 'package:nebula_id/model/nebula.dart';
import 'package:nebula_id/presenter/presenter.dart';

class Auth implements APIResult {
  final String company;
  final String encrypt;
  final String secret;
  final String user;
  final String uuid;
  final Nebula nebula;
  static String _token;

  Auth(
      {this.company,
      this.encrypt,
      this.secret,
      this.user,
      this.uuid,
      this.nebula});

  getToken() => ApiPresenter.user(this).getToken();

  Future<Map<String, String>> buildHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
      'integrity': encrypt
    };
  }

  @override
  void onError(DioError err) => nebula.onError(err.message);

  @override
  void onResult(value) {
    _token = value.toString();
    nebula.onToken(_token);
  }
}
