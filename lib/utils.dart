import 'package:flutter/material.dart';

class Pages {
  static const String Home = 'home';
  static const String Join = 'join';
  static const String Lobby = 'lobby';
  static const String Game = 'game';
  static const String Settings = 'settings';
}

class Utils {
  static void msg(BuildContext context, String msg) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 5),
    ));
  }
}
