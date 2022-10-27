import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static late final SharedPreferences _prefs;

  static const String _xGPSKey = "xGPS";
  static const String _playerGPSKey = "playerGPS";
  static const String _darkKey = "dark";
  static const String _nameKey = "name";

  /// time between position updates from mister x, in minutes
  static late int xGPSInterval;

  /// in seconds
  static late int playerGPSInterval;
  static bool darkMode = true;
  static String playerName = "Player";

  static Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    xGPSInterval = _prefs.getInt(_xGPSKey) ?? 1;
    playerGPSInterval = _prefs.getInt(_playerGPSKey) ?? 30;
    darkMode = _prefs.getBool(_darkKey) ?? true;
    playerName = _prefs.getString(_nameKey) ?? "Player";
  }

  static void save() {
    _prefs.setInt(_xGPSKey, xGPSInterval);
    _prefs.setInt(_playerGPSKey, playerGPSInterval);
    _prefs.setBool(_darkKey, darkMode);
    _prefs.setString(_nameKey, playerName);
  }
}
