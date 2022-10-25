import 'package:flutter/material.dart';

import '../api.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
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
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (await API.instance.startGame() && context.mounted) {
                    Navigator.pushNamed(context, 'game');
                  }
                },
                child: const Text('Start'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await API.instance.leaveLobby() && context.mounted) {
                    Navigator.maybePop(context);
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
