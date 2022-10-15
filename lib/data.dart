import 'package:latlong2/latlong.dart';

class Data {
  late int id;
  late String name;
  late String lobbyCode;

  void updatePlayerPos(int id, LatLng pos) {}
  List<LatLng> getPlayerPos() {
    return [];
  }

  void createLobby() {}
  void joinLobby(String code) {}
}
