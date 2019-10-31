import 'package:shared_preferences/shared_preferences.dart';

class Storage {

  saveBool(key, value) async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }
  deleteString(key) async {
    var pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }
  deleteBool(key) async {
    var pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }
  Future<bool> getBool(key) async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? true;
  }
}
