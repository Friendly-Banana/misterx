import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

import 'api.dart';

class RealAPI extends API {
  static const String serverUrl = "localhost:8080";
  Map<String, String> headers = {};
  final Client _client = Client();

  late String lobbyCode;
  late int localPlayerID;
  @override
  get localPlayer => player.firstWhere((player) => player.id == localPlayerID);

  void updateCookie(Response response) {
    String? cookies = response.headers['set-cookie'];
    if (cookies != null) {
      headers['cookie'] = cookies;
    }
  }

  Future<String> _request(String url, Future<Response> Function() call) async {
    Response response;
    try {
      response = await call();
      updateCookie(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body;
      }
    } catch (e) {
      throw Exception('Unable to fetch $url from the REST API: $e');
    }
    throw Exception('Bad API response: ${response.statusCode}');
  }

  Future<String> _get(String url) async => _request(
      url, () => _client.get(Uri.https(serverUrl, url), headers: headers));

  Future<String> _post(String url, Map<String, dynamic> data) async => _request(
      url,
      () => _client.post(Uri.https(serverUrl, url),
          body: data, headers: headers));

  @override
  void sendLocalPlayerPos(Position pos) {
    _post("pos", pos.toJson());
  }

  @override
  Future<void> updatePlayers() async {
    final parsed =
        json.decode(await _get("player")).cast<Map<String, dynamic>>();
    player = parsed.map<Player>((json) => Player.fromJson(json)).toList();
    notifyListeners();
  }

  @override
  Future<bool> createLobby() async {
    lobbyCode = await _get("create");
    localPlayerID = 0;
    return true;
  }

  @override
  Future<bool> joinLobby(String code) async {
    await _post("join", {"code": code});
    lobbyCode = code;
    updatePlayers();
    return true;
  }

  @override
  Future<bool> leaveLobby() async {
    await _get("leave");
    lobbyCode = "";
    return true;
  }

  @override
  Future<bool> startGame() async {
    await _get("start");
    return true;
  }

  @override
  Future<bool> kickPlayer(int id) async {
    await _post("kick", {"id": id});
    updatePlayers();
    return true;
  }

  @override
  Future<bool> finish() async {
    await _get("finish");
    return true;
  }
}
