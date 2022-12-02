import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> points;

  // Configuration for this stroke
  final Color color;
  final double strokeWidth;
  final StrokeCap strokeCap;

  const Stroke({
    required this.points,
    this.color = Colors.black,
    this.strokeWidth = 2.0,
    this.strokeCap = StrokeCap.round,
  });

  void addPoint(Offset position) {
    points.add(position);
  }
}
