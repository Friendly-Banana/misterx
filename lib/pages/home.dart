import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../utils.dart';
import 'config.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textController =
        TextEditingController(text: Config.playerName);
    textController.addListener(() => Config.playerName = textController.text);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, Pages.Settings),
              icon: const Icon(Icons.settings))
        ],
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Your Name"),
            SizedBox(
              width: 250,
              child: TextField(
                controller: textController,
                maxLength: 12,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, Pages.Join),
                  child: const Text('Join'),
                ),
                ElevatedButton(
                  onPressed: () => Provider.of<API>(context, listen: false)
                      .createLobby()
                      .then((value) {
                    if (value) {
                      return Navigator.pushNamed(context, Pages.Lobby);
                    } else {
                      Utils.msg(context, "Couldn't create lobby.");
                    }
                  }),
                  child: const Text('Host'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
