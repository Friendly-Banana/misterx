import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../main.dart';
import 'config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(children: [
        _title("Allgemein"),
        SwitchListTile(
          title: const Text("Dark Mode"),
          value: Config.darkMode,
          onChanged: (value) =>
              setState(() => Config.darkMode = App.darkNotifier.value = value),
        ),
        _title("Positions Updates"),
        ListTile(
          title: const Text("Zeit zwischen Updates von Mister X"),
          subtitle: Slider(
              label: "${Config.xGPSInterval}min",
              value: Config.xGPSInterval.toDouble(),
              onChanged: (double value) =>
                  setState(() => Config.xGPSInterval = value.toInt()),
              divisions: 15,
              min: 1,
              max: 15),
        ),
        ListTile(
          title: const Text("Zeit zwischen Updates der Spieler"),
          subtitle: Slider(
              label: "${Config.playerGPSInterval}s",
              value: Config.playerGPSInterval.toDouble(),
              onChanged: (double value) =>
                  setState(() => Config.playerGPSInterval = value.toInt()),
              divisions: (120 - 10) ~/ 5,
              min: 10,
              max: 120),
        ),
        _title("Rechtliches"),
        FutureBuilder(
          future: PackageInfo.fromPlatform(),
          builder: (context, data) {
            if (data.hasData) {
              return AboutListTile(
                applicationName: data.requireData.appName,
                applicationVersion:
                    "${data.requireData.version}-build${data.requireData.buildNumber}",
                applicationIcon: Image.asset(
                  "assets/icon.png",
                  width: 80,
                ),
                applicationLegalese: "©2022 Banana",
              );
            }
            return const ListTile(
              title: Text("Loading..."),
            );
          },
        )
      ]),
    );
  }

  ListTile _title(String text) {
    return ListTile(
        title: Text(
      text,
      style: TextStyle(color: Theme.of(context).indicatorColor),
    ));
  }
}
