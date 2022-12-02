import 'dart:ui';

import 'package:drawing_app/src/stroke.dart';
import 'package:flutter/material.dart';

class CanvasPainter extends CustomPainter {
  final List<Stroke> points;

  CanvasPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (Stroke stroke in points) {
      if (stroke.points.isEmpty) continue;
      Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth;
      List<Offset> outlinePoints = stroke.points;
      Path path = Path();
      if (stroke.points.length < 2) {
        path.addOval(Rect.fromCircle(
            center: Offset(outlinePoints[0].dx, outlinePoints[0].dy),
            radius: 1));
      } else {
        path.moveTo(outlinePoints[0].dx, outlinePoints[0].dy);

        for (int i = 1; i < outlinePoints.length - 1; ++i) {
          final p0 = outlinePoints[i];
          final p1 = outlinePoints[i + 1];
          path.quadraticBezierTo(
              p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
