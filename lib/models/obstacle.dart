import 'package:flutter/material.dart';

class Obstacle {
  final double width, height, y;

  double x, dx;
  final Color color;

  Obstacle({
    @required this.width,
    @required this.height,
    @required this.x,
    @required this.y,
    @required this.dx,
    @required this.color,
  });

  void move() {
    this.x -= this.dx;
  }

  Widget get getObstacle => Transform.translate(
        offset: new Offset(
          this.x,
          this.y,
        ),
        child: Container(
          width: this.width,
          height: this.height,
          color: this.color,
        ),
      );
}
