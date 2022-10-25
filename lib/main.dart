import 'package:flutter/material.dart';
import 'package:misterx/pages/config.dart';
import 'package:misterx/pages/game.dart';
import 'package:misterx/pages/home.dart';
import 'package:misterx/pages/join.dart';
import 'package:misterx/pages/lobby.dart';
import 'package:misterx/pages/settings.dart';
import 'package:misterx/utils.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  static ValueNotifier<bool> darkNotifier = ValueNotifier(Config.darkMode);

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    Config.load();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      Config.save();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: App.darkNotifier,
      builder: (BuildContext context, bool value, Widget? child) => MaterialApp(
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
    );
  }
}
