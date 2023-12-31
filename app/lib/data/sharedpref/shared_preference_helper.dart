import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // General Methods: ----------------------------------------------------------
  Future<String?> get authToken async {
    return _sharedPreference.getString(Preferences.auth_token);
  }

  Future<bool> saveAuthToken(String authToken) async {
    return _sharedPreference.setString(Preferences.auth_token, authToken);
  }

  Future<bool> removeAuthToken() async {
    return _sharedPreference.remove(Preferences.auth_token);
  }

  // Login:---------------------------------------------------------------------
  Future<bool> get isLoggedIn async {
    return _sharedPreference.getBool(Preferences.is_logged_in) ?? false;
  }

  Future<bool> saveIsLoggedIn(bool value) async {
    return _sharedPreference.setBool(Preferences.is_logged_in, value);
  }

  // Theme:------------------------------------------------------
  bool get isDarkMode {
    return _sharedPreference.getBool(Preferences.is_dark_mode) ?? false;
  }

  Future<void> changeBrightnessToDark(bool value) {
    return _sharedPreference.setBool(Preferences.is_dark_mode, value);
  }

  // Language:---------------------------------------------------
  String? get currentLanguage {
    return _sharedPreference.getString(Preferences.current_language);
  }

  Future<void> changeLanguage(String language) {
    return _sharedPreference.setString(Preferences.current_language, language);
  }

  // Onboarding:---------------------------------------------------
  Future<bool> get showOnboarding async {
    return _sharedPreference.getBool(Preferences.show_onboarding) ?? true;
  }

  Future<bool> saveShowOnboarding(bool value) {
    return _sharedPreference.setBool(Preferences.show_onboarding, value);
  }

  // Ishihara answer: ----------------------------------------------------------
  String? get ishiharaAnswers {
    return _sharedPreference.getString(Preferences.ishihara_answer);
  }

  Future<void> changeIshiharaAnswers(String answers) {
    return _sharedPreference.setString(Preferences.ishihara_answer, answers);
  }

  // Ishihara result: ----------------------------------------------------------
  String? get ishiharaResult {
    return _sharedPreference.getString(Preferences.ishihara_result);
  }

  Future<void> setIshiharaResult(String result) {
    return _sharedPreference.setString(Preferences.ishihara_result, result);
  }

  // Ishihara result percentage: -----------------------------------------------
  double? get ishiharaResultPercentage {
    return _sharedPreference.getDouble(Preferences.ishihara_result_percentage);
  }

  Future<void> setIshiharaResultPercengate(double percentage) {
    return _sharedPreference.setDouble(Preferences.ishihara_result_percentage, percentage);
  }
}