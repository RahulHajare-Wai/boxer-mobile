import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> cacheToken(String token) async {
    await _prefs.setString(AppConstants.keyAccessToken, token);
    await _prefs.setBool(AppConstants.keyIsLoggedIn, true);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(AppConstants.keyAccessToken);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(AppConstants.keyAccessToken);
    await _prefs.setBool(AppConstants.keyIsLoggedIn, false);
  }
}
