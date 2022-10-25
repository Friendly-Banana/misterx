import 'package:flutter/material.dart';
import 'package:misterx/pages/game.dart';
import 'package:misterx/pages/home.dart';
import 'package:misterx/pages/lobby.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mister X',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'home',
        routes: {
          'home': (context) => const HomePage(),
          'lobby': (context) => const LobbyPage(),
          'game': (context) => const GamePage(),
          'settings': (context) => const GamePage(),
        });
  }
}
