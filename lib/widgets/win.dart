import 'package:flutter/material.dart';

Future win(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Text("You won!");
      });
}
