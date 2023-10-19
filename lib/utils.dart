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

  static Text? distanceText(Player one, Player two) {
    LatLng a = one.pos!, b = two.pos!;
    //if (one.pos == null || two.pos == null) return null;
    var km = distance.as(LengthUnit.Kilometer, a, b);
    return Text(km > 1 ? "${km}km" : "${distance.as(LengthUnit.Meter, a, b)}m");
  }
}
