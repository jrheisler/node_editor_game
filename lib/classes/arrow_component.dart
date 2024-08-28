import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'node.dart';

class ArrowComponent extends PositionComponent {
  SimpleNode startNode;
  SimpleNode endNode;
  final Color color;
  final double arrowHeadSize = 10.0;

  ArrowComponent({
    required this.startNode,
    required this.endNode,
    required this.color,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2.0;

    // Calculate the current positions of the start and end nodes
    final start = startNode.position + Vector2(startNode.size.x / 2, startNode.size.y / 2);
    final end = endNode.position + Vector2(endNode.size.x / 2, endNode.size.y / 2);

    // Draw the arrow line
    canvas.drawLine(Offset(start.x, start.y), Offset(end.x, end.y), paint);

    // Calculate the angle of the line
    final lineAngle = atan2(end.y - start.y, end.x - start.x);

    // Draw the arrowhead
    final arrowAngle = 0.5; // Angle of the arrowhead in radians
    final arrowPoint = Offset(end.x, end.y);
    final arrowPath = Path()
      ..moveTo(arrowPoint.dx, arrowPoint.dy)
      ..lineTo(
        arrowPoint.dx - arrowHeadSize * cos(lineAngle - arrowAngle),
        arrowPoint.dy - arrowHeadSize * sin(lineAngle - arrowAngle),
      )
      ..lineTo(
        arrowPoint.dx - arrowHeadSize * cos(lineAngle + arrowAngle),
        arrowPoint.dy - arrowHeadSize * sin(lineAngle + arrowAngle),
      )
      ..close();

    canvas.drawPath(arrowPath, paint);
  }

  @override
  void update(double dt) {
    // No need for specific update logic if we are just rendering based on node positions
    // The render method will automatically reflect the current positions of the nodes
  }
}
