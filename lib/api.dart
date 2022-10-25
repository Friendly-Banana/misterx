import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:misterx/utils.dart';

class API extends ChangeNotifier {
  static const String url = "localhost:1234/api/";
  static API instance = API();
  late String lobbyCode;
  late int localPlayerID;
  List<Player> player = [];

  get localPlayer => player.firstWhere((player) => player.id == localPlayerID);

  Map<String, String> _request() {
    return {};
  }

  void sendLocalPlayerPos(LatLng pos) {}

  void updatePlayer() {
    player = [];
    notifyListeners();
  }

  Future<bool> createLobby() async {
    localPlayerID = 0;
    lobbyCode = "";
    return false;
  }

  Future<bool> joinLobby(String code) async {
    localPlayerID = -1;
    return false;
  }

  Future<bool> leaveLobby() async {
    return false;
  }

  Future<bool> startGame() async {
    return false;
  }

  Future<bool> kickPlayer(int id) async {
    return false;
  }

  Widget playerItem(BuildContext context, int index) {
    return ListTile(
      title: Text(player[index].name),
      subtitle: Text(player[index].pos.toString()),
      trailing: IconButton(
          onPressed: () async {
            if (!await kickPlayer(player[index].id)) {
              Utils.msg(context, "Kicking ${player[index]} failed.");
            }
          },
          icon: const Icon(Icons.cancel)),
    );
  }
}

class Player {
  int id;
  String name;
  bool mrX;
  LatLng pos;

  Player(this.id, this.name, this.mrX, this.pos);
}
