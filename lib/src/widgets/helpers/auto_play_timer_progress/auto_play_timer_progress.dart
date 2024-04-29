import 'dart:math';

import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';

class PrettyAutoPlayTimerProgressPainter extends CustomPainter {
  PrettyAutoPlayTimerProgressPainter({
    this.animation,
    PrettyAutoPlayTimerProgressColors? colors,
  })  : this.colors = colors ?? PrettyAutoPlayTimerProgressColors(),
        super(repaint: animation);

  final Animation<double>? animation;
  final PrettyAutoPlayTimerProgressColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = colors.backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = colors.color;
    double progress = (1.0 - animation!.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(PrettyAutoPlayTimerProgressPainter old) {
    return false;
  }
}
