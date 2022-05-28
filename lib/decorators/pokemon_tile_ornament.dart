import 'dart:math';

import "package:flutter/material.dart";

class CurvedPainter extends CustomPainter {
  final Color color;
  final bool isSecondType;

  CurvedPainter(this.color, {this.isSecondType = false});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;
    var path = Path();

    List<Point<double>> points = [
      Point(0, size.height / 20),
      Point(9 * size.width / 10, 0),
      Point(size.width, size.height / 10),
      Point(size.width, size.height),
      Point(9 * size.width / 10, 9 * size.height / 10),
      Point(9 * size.width / 10, 2 * size.width / 10),
      Point(8 * size.width / 10, size.width / 10),
      Point(size.width / 10, size.width / 10),
      Point(0, size.height / 20),
    ];

    if (isSecondType) {
      path.moveTo(size.width - points[0].x / 1, size.height - points[0].y / 1);
    } else {
      path.moveTo(points[0].x / 1, points[0].y / 1);
    }
    for (int i = 0; i < points.length - 1; ++i) {
      final p0 =
          isSecondType ? Point(size.width, size.height) - points[i] : points[i];
      final p1 = isSecondType
          ? Point(size.width, size.height) - points[i + 1]
          : points[i + 1];
      path.quadraticBezierTo(p0.x, p0.y, (p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
