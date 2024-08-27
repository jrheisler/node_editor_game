import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class SimpleNode extends PositionComponent {
  final Color color;
  final String shape; // This can be 'circle', 'square', 'diamond'

  SimpleNode({
    required Vector2 position,
    required Vector2 size,
    required this.color,
    required this.shape,
  }) : super(position: position, size: size) {
    // Debug: Print node creation details
    print('SimpleNode created at position: $position with size: $size and shape: $shape');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = color;

    if (shape == 'circle') {
      canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
    } else if (shape == 'square') {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    } else if (shape == 'diamond') {
      Path diamondPath = Path();
      diamondPath.moveTo(size.x / 2, 0);
      diamondPath.lineTo(0, size.y / 2);
      diamondPath.lineTo(size.x / 2, size.y);
      diamondPath.lineTo(size.x, size.y / 2);
      diamondPath.close();
      canvas.drawPath(diamondPath, paint);
    }
  }

  @override
  bool containsPoint(Vector2 point) {
    final Rect nodeRect = Rect.fromLTWH(position.x, position.y, size.x, size.y);
    final contains = nodeRect.contains(Offset(point.x, point.y));
    print('Checking if point $point is within node bounds $nodeRect: $contains');
    return contains;
  }
}



class Node extends PositionComponent {
  final Color color;

  Node({
    required Vector2 position,
    required Vector2 size,
    required this.color,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = color;
    canvas.drawRect(toRect(), paint);
  }

  @override
  bool containsPoint(Vector2 point) {
    // This method checks if the given point is within the node's bounds
    return toRect().contains(point.toOffset());
  }
}


/*class StartNode extends Node {
  StartNode({
    required Vector2 position,
    required double radius,
  }) : super(
    position: position,
    size: Vector2.all(radius * 2),
    color: const Color(0xFF4CAF50), // Green color for StartNode
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = color;
    canvas.drawCircle(size.toOffset() / 2, size.x / 2, paint);
  }
}





class ProcessNode extends Node {
  ProcessNode({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    position: position,
    size: size,
    color: const Color(0xFF2196F3), // Blue color for ProcessNode
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = color;
    canvas.drawRect(toRect(), paint);
  }
}



class DecisionNode extends Node {
  DecisionNode({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    color: const Color(0xFFFFC107),
    size: size,
    position: position,
  );

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y / 2)
      ..lineTo(size.x / 2, size.y)
      ..lineTo(0, size.y / 2)
      ..close();
    canvas.drawPath(path, paint);
  }
}


class StopNode extends Node {
  StopNode({
    required Vector2 position,
    required double radius,
  }) : super(
    color: const Color(0xFFF44336),
    size: Vector2.all(radius * 2),
    position: position,
  );

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawCircle(size.toOffset() / 2, size.x / 2, paint);
  }
}
*/

