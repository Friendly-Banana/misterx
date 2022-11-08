import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Player {
  int id;
  String name;
  bool mrX;
  LatLng? pos;

  Player(this.id, this.name, this.mrX, this.pos);

  factory Player.fromJson(Map<String, dynamic> data) {
    return Player(
      data['id'],
      data['name'],
      data['mister_x'],
      coordsFromJSON(data),
    );
  }

  static Map<String, dynamic> coordsToJSON(Position pos) =>
      {"coordinates": "${pos.longitude} ${pos.latitude}"};
  static LatLng? coordsFromJSON(Map<String, dynamic> data) {print(data );
    return data['pos'] != null
        ? LatLng.fromJson(
            {'coordinates': data['pos'].split(" ").map(double.parse).toList()})
        : null;
  }
}

abstract class API extends ChangeNotifier {
  bool authenticated = false;
  bool gameFinished = false;
  List<Player> player = [];
  Player get localPlayer;

  void sendLocalPlayerPos(Position pos);

  Future<void> updatePlayers();

  Future<bool> createLobby();

  Future<bool> joinLobby(String code);

  Future<bool> leaveLobby();

  Future<bool> startGame();

  Future<bool> kickPlayer(int id);

  Future<bool> finish();
}
