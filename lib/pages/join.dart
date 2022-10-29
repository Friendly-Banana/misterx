import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../utils.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  bool validCode = false;
  TextEditingController textController = TextEditingController();

  void checkCode() => setState(() {
        validCode = textController.text == "bad";
      });

  @override
  void initState() {
    super.initState();
    textController.addListener(checkCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Lobby'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Input your lobby code"),
            SizedBox(
              width: 200,
              child: TextField(
                controller: textController,
                maxLength: 10,
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              key: const Key("joinButton"),
              onPressed: validCode
                  ? null
                  : () => Provider.of<API>(context, listen: false)
                          .joinLobby(textController.text)
                          .then((success) {
                        if (success) {
                          Navigator.pushNamed(context, Pages.Lobby);
                        } else {
                          Utils.msg(context, "Couldn't find lobby.");
                        }
                      }),
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
