import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setToken(String token) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString('token');
  }

  void setIsAuthor(bool isAuthor) async {
    SharedPreferences prefs = await _prefs;
    prefs.setBool('isAuthor', isAuthor);
  }

  Future<bool?> getIsAuthor() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getBool('isAuthor');
  }

  void setLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await _prefs;
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<bool?> getLoggedIn() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getBool('isLoggedIn');
  }
}
