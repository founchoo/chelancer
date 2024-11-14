import 'package:shared_preferences/shared_preferences.dart';

class DataStorage {
  static SharedPreferences? prefs;

  static const keyDarkMode = 'darkMode';
  static const defaultValueDarkMode = 'Follow system';

  static const keyIsSysColor = 'sysColor';
  static const defaultValueIsSysColor = false;

  /// Init SharedPreferences
  static Future<void> initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}
