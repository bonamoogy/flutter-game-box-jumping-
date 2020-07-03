import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import '../settings/game-setting.dart';

class Player {
  final double width, height, x;

  double y, _dy = 0, _jumpForce = 15.0;
  final Color color;

  bool _canJump = true;

  final _audioCache = new AudioCache();
  AudioPlayer _audioPlayer;

  Player({
    @required this.width,
    @required this.height,
    @required this.x,
    @required this.y,
    @required this.color,
  });

  void updatePlayer() {
    this.y += this._dy;
    if (this.height + this.y < mainHeight) {
      _dy += gravity;
      _canJump = false;
    } else {
      _canJump = true;
      _dy = 0;
      this.y = mainHeight - this.height;
    }
  }

  void jump() async {
    if (_canJump) {
      _dy -= _jumpForce;
      _audioPlayer = await _audioCache.play('audios/jump.mp3');
    }
  }

  void dis() {
    _audioPlayer.dispose();
  }

  Widget get getPlayer => Transform.translate(
        offset: new Offset(this.x, this.y),
        child: new Container(
          width: this.width,
          height: this.height,
          color: this.color,
        ),
      );
}
