import 'package:flutter/material.dart';
import 'package:misterx/pages/config.dart';
import 'package:misterx/pages/game.dart';
import 'package:misterx/pages/home.dart';
import 'package:misterx/pages/join.dart';
import 'package:misterx/pages/lobby.dart';
import 'package:misterx/pages/settings.dart';
import 'package:misterx/utils.dart';
import 'package:provider/provider.dart';

import 'api/api.dart';
import 'api/realapi.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> with WidgetsBindingObserver {
  static final ValueNotifier<bool> darkNotifier =
      ValueNotifier(Config.darkMode);

  @override
  void initState() {
    super.initState();
    Config.load();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<API>(
        create: (context) => RealAPI(),
        child: ValueListenableBuilder(
          valueListenable: darkNotifier,
          builder: (BuildContext context, bool value, Widget? child) =>
              MaterialApp(
                  title: 'Mister X',
                  theme: value ? ThemeData.dark() : ThemeData.light(),
                  initialRoute: Pages.Home,
                  routes: {
                Pages.Home: (context) => const HomePage(),
                Pages.Join: (context) => const JoinPage(),
                Pages.Lobby: (context) => const LobbyPage(),
                Pages.Game: (context) => const GamePage(),
                Pages.Settings: (context) => const SettingsPage(),
              }),
        ));
  }
}
