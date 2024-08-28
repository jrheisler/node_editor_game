import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ArrowComponent extends PositionComponent {
  Vector2 start;
  Vector2 end;
  final Color color;

  ArrowComponent({
    required this.start,
    required this.end,
    required this.color,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0;

    // Draw the main line
    canvas.drawLine(Offset(start.x, start.y), Offset(end.x, end.y), paint);

    // Draw the arrowhead
    drawArrowhead(canvas, start, end, paint);
  }

  void drawArrowhead(Canvas canvas, Vector2 start, Vector2 end, Paint paint) {
    final arrowLength = 10.0;
    final arrowAngle = pi / 4; // Angle of arrowhead, 45 degrees in radians
    final lineAngle = atan2(end.y - start.y, end.x - start.x); // Calculate the angle of the line

    // Calculate the position of the arrowhead point
    final arrowPoint = end;

    // Calculate the two points for the arrowhead's base
    final leftPoint = arrowPoint + Vector2(
      -arrowLength * cos(lineAngle - arrowAngle),
      -arrowLength * sin(lineAngle - arrowAngle),
    );

    final rightPoint = arrowPoint + Vector2(
      -arrowLength * cos(lineAngle + arrowAngle),
      -arrowLength * sin(lineAngle + arrowAngle),
    );

    // Draw the two lines to form the arrowhead
    canvas.drawLine(Offset(arrowPoint.x, arrowPoint.y), Offset(leftPoint.x, leftPoint.y), paint);
    canvas.drawLine(Offset(arrowPoint.x, arrowPoint.y), Offset(rightPoint.x, rightPoint.y), paint);
  }
}
