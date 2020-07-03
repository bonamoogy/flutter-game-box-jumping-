import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import './settings/game-setting.dart';

import './models/player.dart';
import './models/obstacle.dart';

class GameMain extends StatefulWidget {
  GameMain({Key key}) : super(key: key);

  @override
  _GameMainState createState() => _GameMainState();
}

class _GameMainState extends State<GameMain>
    with SingleTickerProviderStateMixin {
  AnimationController _mainController;

  Player _mPlayer;
  List<Obstacle> _obstacles = <Obstacle>[];

  bool _gameIsStart = false;
  int _score = 0;

  final _audioCache = new AudioCache();
  AudioPlayer _audioPlayer;

  @override
  void initState() {
    _createPlayer();
    _mainController = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _mainController.addListener(_update);
    _mainController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _audioPlayer.dispose();
    _mPlayer.dis();
    super.dispose();
  }

  void _update() {
    if (_mPlayer != null) {
      setState(() {
        _mPlayer.updatePlayer();
        if (_gameIsStart) {
          gameSpeed += 0.0003;
          spawnObstacle--;
          _score++;

          if (spawnObstacle <= 0) {
            _createObstacle();
          }

          _obstacles.forEach((obs) {
            obs.move();

            if (_mPlayer.width + _mPlayer.x >= obs.x &&
                _mPlayer.x <= obs.x + obs.width &&
                _mPlayer.y + _mPlayer.height >= obs.y &&
                _mPlayer.y <= obs.y + obs.height) {
              _gameOver();
            }
          });
        }
      });
    }
  }

  void _gameOver() async {
    _gameIsStart = false;
    _obstacles = [];
    gameSpeed = initGameSpeed;
    spawnObstacle = initSpawnObstacle;
    _score = 0;
    await _audioPlayer.stop();
  }

  void _createObstacle() {
    final randomSpawnObstacle = _createRandomValue(50, 100);
    final randomValObs = _createRandomValue(20, 40);

    final obs = new Obstacle(
      width: randomValObs,
      height: randomValObs,
      x: MediaQuery.of(context).size.width - randomValObs,
      y: mainHeight - randomValObs,
      dx: gameSpeed,
      color: Colors.yellow,
    );

    _obstacles.add(obs);
    spawnObstacle = randomSpawnObstacle;
  }

  double _createRandomValue(int min, int max) {
    final result = min + Random().nextInt(max - min);
    return result.toDouble();
  }

  void _createPlayer() {
    _mPlayer = new Player(
      width: 25,
      height: 25,
      x: 20,
      y: mainHeight - 25,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text("Flutter Game Box Jumping!"),
            centerTitle: true,
            elevation: .0,
          ),
          body: _main,
        ),
        if (!_gameIsStart)
          Opacity(
            opacity: .6,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black87,
            ),
          ),
        if (!_gameIsStart)
          Center(
            child: TapFadeText(
              child: FlatButton(
                onPressed: () async {
                  _gameIsStart = true;

                  _audioPlayer = await _audioCache.play('audios/main-game.mp3');
                },
                child: Text(
                  'Tap Here To Play The Game!',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }

  void _jump() {
    if (_gameIsStart) _mPlayer.jump();
  }

  Widget get _main => GestureDetector(
        onTap: _jump,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Text(
                'Your Score : ' + _score.toString(),
                style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            Center(
              child: Container(
                width: mainWidth,
                height: mainHeight,
                color: backgroundMainColor,
                child: Stack(
                  children: <Widget>[
                    _mPlayer.getPlayer,
                    Stack(
                      children:
                          _obstacles.map((obs) => obs.getObstacle).toList(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class TapFadeText extends StatefulWidget {
  final Widget child;
  TapFadeText({
    @required this.child,
  });

  @override
  _TapFadeTextState createState() => _TapFadeTextState();
}

class _TapFadeTextState extends State<TapFadeText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _anim;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _anim = new Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: widget.child,
    );
  }
}
