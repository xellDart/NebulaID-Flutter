abstract class Nebula {
  onResult(dynamic result);
  onToken(String result);
  onUUID(String result);
  onError(String error);
}

class Access {
  String uuid;
  Access(this.uuid);
}