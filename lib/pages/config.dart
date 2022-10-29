import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class ConfigValue<T> {
  String key;
  T value;
  String Function(T)? encoder;
  T Function(String)? decoder;

  ConfigValue(this.key, this.value, [this.encoder, this.decoder]);

  void load() {
    // default value set by ctor
    if (!Config._prefs.containsKey(key)) return;
    if (decoder != null) {
      value = decoder!.call(Config._prefs.getString(key)!);
    } else {
      switch (T) {
        case String:
          value = Config._prefs.getString(key)! as T;
          break;
        case int:
          value = Config._prefs.getInt(key)! as T;
          break;
        case double:
          value = Config._prefs.getDouble(key)! as T;
          break;
        case bool:
          value = Config._prefs.getBool(key)! as T;
          break;
        case List<String>:
          value = Config._prefs.getStringList(key)! as T;
          break;
        default:
          log("Please define decoder for type $T");
          break;
      }
    }
  }

  void set(T newValue) {
    value = newValue;
    if (encoder != null) {
      Config._prefs.setString(key, encoder!.call(newValue));
    } else {
      switch (T) {
        case String:
          Config._prefs.setString(key, value as String);
          break;
        case int:
          Config._prefs.setInt(key, value as int);
          break;
        case double:
          Config._prefs.setDouble(key, value as double);
          break;
        case bool:
          Config._prefs.setBool(key, value as bool);
          break;
        case List<String>:
          Config._prefs.setStringList(key, value as List<String>);
          break;
        default:
          log("Please define encoder for type $T");
          break;
      }
    }
  }
}

class Config {
  static late final SharedPreferences _prefs;

  static final ConfigValue<bool> _darkMode = register("darkMode", true);
  static get darkMode => _darkMode.value;
  static set darkMode(s) => _darkMode.set(s);

  /// in seconds
  static final ConfigValue<int> _playerGPSInterval =
      register("playerGPSInterval", 30);
  static get playerGPSInterval => _playerGPSInterval.value;
  static set playerGPSInterval(s) => _playerGPSInterval.set(s);

  /// time between position updates from mister x, in minutes
  static final ConfigValue<int> _xGPSInterval = register("xGPSInterval", 1);
  static get xGPSInterval => _xGPSInterval.value;
  static set xGPSInterval(s) => _xGPSInterval.set(s);

  static final ConfigValue<String> _playerName =
      register("playerName", "Player");
  static get playerName => _playerName.value;
  static set playerName(s) => _playerName.set(s);

  static final List<ConfigValue> _values = [];

  static ConfigValue<T> register<T>(String key, T value) {
    var cfg = ConfigValue(key, value);
    _values.add(cfg);
    return cfg;
  }

  static Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    for (var value in _values) {
      value.load();
    }
  }
}
