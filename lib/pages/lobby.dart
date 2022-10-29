import 'dart:async';

import 'package:flutter/material.dart';
import 'package:misterx/utils.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  late final Timer refresh;
  @override
  void initState() {
    super.initState();
    refresh = Timer.periodic(const Duration(seconds: 10),
        (timer) => Provider.of<API>(context, listen: false).updatePlayers());
  }

  @override
  void dispose() {
    refresh.cancel();
    super.dispose();
  }

  Widget playerItem(BuildContext context, int index, API api) {
    Player player = api.player[index];
    return ListTile(
      title: Text(player.name),
      subtitle: Utils.distanceText(api.localPlayer, player),
      trailing: IconButton(
          onPressed: () async {
            if (!await api.kickPlayer(player.id)) {
              Utils.msg(context, "Kicking ${player.name} failed.");
            }
          },
          icon: const Icon(Icons.cancel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<API>(
      builder: (context, api, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Lobby'),
          leading: BackButton(
            onPressed: () => api.leaveLobby().then((value) {
              if (value) {
                Navigator.pop(context);
              } else {
                Utils.msg(context, "Couldn't find lobby.");
              }
            }),
          ),
        ),
        body: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => playerItem(context, index, api),
              itemCount: api.player.length,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (await api.leaveLobby() && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Leave'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (await api.startGame() && context.mounted) {
                      Navigator.pushNamed(context, Pages.Game);
                    }
                  },
                  child: const Text('Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
