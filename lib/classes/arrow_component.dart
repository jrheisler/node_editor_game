import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ArrowComponent extends PositionComponent {
  final Vector2 start;
  Vector2 end;
  final Color color;
  final double arrowHeadSize = 10.0;

  ArrowComponent({
    required this.start,
    required this.end,
    required this.color,
  });

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0;

    // Calculate control points for the Bezier curve
    final controlPoint1 = Vector2(start.x + (end.x - start.x) / 2, start.y);
    final controlPoint2 = Vector2(end.x, end.y - (end.y - start.y) / 2);

    // Draw the Bezier curve
    final path = Path()
      ..moveTo(start.x, start.y)
      ..cubicTo(controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, end.x, end.y);
    canvas.drawPath(path, paint);

    // Calculate the position at 2/3 along the curve for the arrowhead
    final arrowPoint = interpolateBezier(start, controlPoint1, controlPoint2, end, 0.66);

    // Draw the arrowhead
    final arrowPath = Path()
      ..moveTo(arrowPoint.x, arrowPoint.y)
      ..lineTo(arrowPoint.x - arrowHeadSize, arrowPoint.y - arrowHeadSize / 2)
      ..lineTo(arrowPoint.x - arrowHeadSize, arrowPoint.y + arrowHeadSize / 2)
      ..close();

    canvas.drawPath(arrowPath, paint);
  }

  Vector2 interpolateBezier(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, double t) {
    final x = _cubicBezier(p0.x, p1.x, p2.x, p3.x, t);
    final y = _cubicBezier(p0.y, p1.y, p2.y, p3.y, t);
    return Vector2(x, y);
  }

  double _cubicBezier(double p0, double p1, double p2, double p3, double t) {
    return (1 - t) * (1 - t) * (1 - t) * p0 +
        3 * (1 - t) * (1 - t) * t * p1 +
        3 * (1 - t) * t * t * p2 +
        t * t * t * p3;
  }

  @override
  bool containsPoint(Vector2 point) {
    // Override this method if you want to detect clicks on the arrow.
    return false;
  }
}
