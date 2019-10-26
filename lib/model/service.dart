abstract class Service {
  saveFace(Map data);
  Future<String> createUser();
  Future<Map> validFace(Map data);
  Future<String> getToken();
}