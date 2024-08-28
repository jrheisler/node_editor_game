import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class PaletteComponent extends PositionComponent {
  final Function(String nodeType, Offset position) onNodeSelected;

  PaletteComponent({required this.onNodeSelected});

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Define the padding and spacing
    const double padding = 20.0;
    const double shapeSize = 50.0;
    final Paint faintLinePaint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 2.0;

    // Draw the separating line
    canvas.drawLine(Offset(100, 0), Offset(100, size.y), faintLinePaint);

    // Calculate positions for each node
    final double startY = padding;
    final double processY = startY + shapeSize + padding;
    final double decisionY = processY + shapeSize + padding;
    final double stopY = decisionY + shapeSize + padding;

    // Start Node: Green Circle
    final startPaint = Paint()..color = const Color(0xFF4CAF50);
    canvas.drawCircle(Offset(50, startY + shapeSize / 2), shapeSize / 2, startPaint);

    // Process Node: Blue Square
    final processPaint = Paint()..color = const Color(0xFF2196F3);
    canvas.drawRect(Rect.fromLTWH(25, processY, shapeSize, shapeSize), processPaint);

    // Decision Node: Yellow Diamond
    final decisionPaint = Paint()..color = const Color(0xFFFFEB3B);
    Path diamondPath = Path();
    diamondPath.moveTo(50, decisionY);
    diamondPath.lineTo(25, decisionY + shapeSize / 2);
    diamondPath.lineTo(50, decisionY + shapeSize);
    diamondPath.lineTo(75, decisionY + shapeSize / 2);
    diamondPath.close();
    canvas.drawPath(diamondPath, decisionPaint);

    // Stop Node: Red Circle
    final stopPaint = Paint()..color = const Color(0xFFF44336);
    canvas.drawCircle(Offset(50, stopY + shapeSize / 2), shapeSize / 2, stopPaint);
  }

  bool handleTap(Offset position) {
    const double padding = 20.0;
    const double shapeSize = 50.0;

    final double startY = padding;
    final double processY = startY + shapeSize + padding;
    final double decisionY = processY + shapeSize + padding;
    final double stopY = decisionY + shapeSize + padding;

    // Detect taps on each shape and trigger node creation with drag
    if ((position - Offset(50, startY + shapeSize / 2)).distance < shapeSize / 2) {
      onNodeSelected('start', position);
      return true;
    } else if (Rect.fromLTWH(25, processY, shapeSize, shapeSize).contains(position)) {
      onNodeSelected('process', position);
      return true;
    } else if (Rect.fromLTWH(25, decisionY - shapeSize / 2, shapeSize, shapeSize).contains(position)) {
      onNodeSelected('decision', position);
      return true;
    } else if ((position - Offset(50, stopY + shapeSize / 2)).distance < shapeSize / 2) {
      onNodeSelected('stop', position);
      return true;
    }
    return false;
  }
}
