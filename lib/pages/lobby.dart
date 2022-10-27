import 'dart:async';

import 'package:flutter/material.dart';
import 'package:misterx/utils.dart';
import 'package:provider/provider.dart';

import '../api.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  late final  Timer refresh;
  @override
  void initState() {
    super.initState();
    API.instance.addListener(() {setState(() {

    });})
   refresh= Timer.periodic(const Duration(seconds: 10), (API.instanceer) => API.instance.updatePlayers());
  }
  
  @override
  void dispose() {
    refresh.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
      ),
      body: Column(
        children: [
          ListView.builder(
            itemBuilder: (context, index) =>
                API.instance.playerItem(context, index),
            itemCount: API.instance.player.length,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (await API.instance.startGame() && mounted) {
                    Navigator.pushNamed(context, Pages.Game);
                  }
                },
                child: const Text('Start'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await API.instance.leaveLobby() && mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Leave'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
