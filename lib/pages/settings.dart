import 'package:flutter/material.dart';

import 'config.dart';

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
      body: ListView(
        children:  [AboutListTile(
          applicationName: Config.packageInfo.appName,
          applicationVersion: Config.appVersion,
          applicationIcon: Image.asset(
            "assets/icon.png",
            width: 80,
          ),
          applicationLegalese: "©2022 Banana",
        ),
        ]),
    );
  }

  ListTile _title(String text) {
    return ListTile(
        title: Text(
          text,
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ));
  }],
      ),
    );
  }
}
