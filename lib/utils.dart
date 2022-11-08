import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:misterx/api/api.dart';

class Pages {
  static const String Home = 'home';
  static const String Join = 'join';
  static const String Lobby = 'lobby';
  static const String Game = 'game';
  static const String Settings = 'settings';
}

class Utils {
  static const Distance distance = Distance();

  static void msg(BuildContext context, String msg) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 5),
    ));
  }

  static Text? distanceText(Player a, Player b) {
    if (a.pos == null || b.pos == null) return null;
    return Text("${distance.as(LengthUnit.Kilometer, a.pos!, b.pos!)}km");
  }
}
