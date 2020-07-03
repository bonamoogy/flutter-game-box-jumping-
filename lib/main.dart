import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './game-main.dart';

void main() {
  runApp(MyApp());

// Force Screen To Landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Game Box Jumping',
      home: GameMain(),
    );
  }
}
