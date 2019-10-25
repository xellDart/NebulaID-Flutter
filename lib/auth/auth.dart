
class Auth {
  final String apiKey;
  final String apiSecret;

  Auth(this.apiKey, this.apiSecret);

  Future<Map<String, String>> buildHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'public-key': apiKey,
      'secret-key': apiSecret
    };
  }
}
