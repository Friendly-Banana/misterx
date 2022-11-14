import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'api.dart';

class TestAPI extends API {
  @override
  Player get localPlayer => player[0];

  @override
  Future<bool> createLobby() async {
    lobbyCode = "Code";
    notifyListeners();
    return true;
  }

  @override
  Future<bool> finish() async {
    gameFinished = true;
    notifyListeners();
    return true;
  }

  @override
  Future<bool> joinLobby(String code) async {
    lobbyCode = "Code";
    updatePlayers();
    return true;
  }

  @override
  Future<bool> kickPlayer(int id) async {
    return true;
  }

  @override
  Future<bool> leaveLobby() async {
    return true;
  }

  @override
  void sendLocalPlayerPos(Position pos) {}

  @override
  Future<bool> startGame() async {
    return true;
  }

  @override
  Future<void> updatePlayers() async {
    player = [
      Player(0, "Player 1", true, LatLng(37.43475395757751, -122.08)),
      Player(1, "Player 2", false, LatLng(37.0, -122.1))
    ];
    notifyListeners();
  }
}
