import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

/// example
/// ```
/// final ConfigValue _p = ConfigValue("player", "a");
/// String get p => _p.value;
/// set p(String s) => _p.set(s);
/// ```
class ConfigValue<T> {
  String key;
  T value;
  String Function(T)? encoder;
  T Function(String)? decoder;

  ConfigValue(this.key, this.value, [this.encoder, this.decoder]) {
    load();
  }

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
  static final Config i = Config();
  final Map<Symbol, ConfigValue> _values = <Symbol, ConfigValue>{};

  @override
  noSuchMethod(Invocation invocation) {
    var key = invocation.memberName;
    if (invocation.isGetter) {
      if (_values.containsKey(key)) {
        return _values[key]?.value;
      } else {
        throw UnsupportedError("add property first");
      }
    }
    if (invocation.isSetter) {
      var value = invocation.positionalArguments.first;
      if (!_values.containsKey(key)) {
        _values[key] = ConfigValue(key.toString(), value);
      }
      _values[key]?.set(value);
    }
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    xGPSInterval = 1;
    playerGPSInterval = 30;
    darkMode = true;
    playerName = "Player";
  }
}
