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