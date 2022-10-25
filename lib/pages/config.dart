import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static late final PackageInfo packageInfo;
  static late final String appVersion;
  static late final SharedPreferences _prefs;

  static Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();

    packageInfo = await PackageInfo.fromPlatform();
    appVersion = "${packageInfo.version}+${packageInfo.buildNumber}";
  }
}
