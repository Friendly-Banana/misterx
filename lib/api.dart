import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:misterx/utils.dart';
import 'package:http/http.dart';

class API extends ChangeNotifier {
  static const String serverUrl = "localhost:1234/api/";
  static API instance = API();
  late String lobbyCode;
  late int localPlayerID;
  Stream<List<Player>> w = Stream();
  List<Player> player = [
    Player(0, "1", true, LatLng(48.126154762110744, 11.579897939780327)),
    Player(1, "2", false, LatLng(48.2, 11.579897939780327)),
  ];

  final Client _client = Client();

  get localPlayer => player.firstWhere((player) => player.id == localPlayerID);

  Future<String> _request(String url) async {
    final response = await _client.get(Uri.https(serverUrl, url));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    }
    throw Exception(
        'Unable to fetch $url from the REST API: ${response.statusCode}');
  }

  Future<String> _post(String url, Map<String, dynamic> data) async {
    final response = await _client.post(Uri.https(serverUrl, url), body: data);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    }
    throw Exception(
        'Unable to fetch $url from the REST API: ${response.statusCode}');
  }

  void sendLocalPlayerPos(LatLng pos) {
    Geolocator.getCurrentPosition()
        .then((value) => _post("pos", value.toJson()));
  }

  Future<void> updatePlayers() async {
    final parsed =
        json.decode(await _request("player")).cast<Map<String, dynamic>>();
    player = parsed.map<Player>((json) => Player.fromJson(json)).toList();
    notifyListeners();
  }

  Future<bool> createLobby() async {
    lobbyCode = await _request("create");
    localPlayerID = 0;
    return true;
  }

  Future<bool> joinLobby(String code) async {
    await _post("join", {"code": code});
    lobbyCode = code;
    updatePlayers();
    return true;
  }

  Future<bool> leaveLobby() async {
    await _request("leave");
    lobbyCode = "";
    return true;
  }

  Future<bool> startGame() async {
    await _request("start");
    return true;
  }

  Future<bool> kickPlayer(int id) async {
    await _post("kick", {"id": id});
    updatePlayers();
    return true;
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

  factory Player.fromJson(Map<String, dynamic> data) {
    return Player(
      data['id'],
      data['name'],
      data['mrX'],
      data['pos'],
    );
  }
}
