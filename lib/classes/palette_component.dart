import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class PaletteComponent extends PositionComponent {
  final Function(String nodeType) onNodeSelected;

  PaletteComponent({required this.onNodeSelected});

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Start Node: Green Circle
    final startPaint = Paint()..color = const Color(0xFF4CAF50);
    canvas.drawCircle(Offset(50, 450), 25, startPaint);

    // Process Node: Blue Square
    final processPaint = Paint()..color = const Color(0xFF2196F3);
    canvas.drawRect(Rect.fromLTWH(25, 300, 50, 50), processPaint);

    // Decision Node: Yellow Diamond
    final decisionPaint = Paint()..color = const Color(0xFFFFEB3B);
    Path diamondPath = Path();
    diamondPath.moveTo(50, 200);
    diamondPath.lineTo(25, 225);
    diamondPath.lineTo(50, 250);
    diamondPath.lineTo(75, 225);
    diamondPath.close();
    canvas.drawPath(diamondPath, decisionPaint);

    // Stop Node: Red Circle
    final stopPaint = Paint()..color = const Color(0xFFF44336);
    canvas.drawCircle(Offset(50, 50), 25, stopPaint);
  }

  bool handleTap(Offset position) {
    // Detect taps on each shape and trigger node creation
    if ((position - Offset(50, 450)).distance < 25) {
      onNodeSelected('start');
      return true;
    } else if (Rect.fromLTWH(25, 300, 50, 50).contains(position)) {
      onNodeSelected('process');
      return true;
    } else if (Rect.fromLTWH(25, 175, 50, 50).contains(position)) {
      onNodeSelected('decision');
      return true;
    } else if ((position - Offset(50, 50)).distance < 25) {
      onNodeSelected('stop');
      return true;
    }
    return false;
  }
}
