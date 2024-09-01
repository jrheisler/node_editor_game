import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

class PaletteComponent extends PositionComponent {
  final Function(String nodeType, Offset position) onNodeSelected;
  final VoidCallback onExport;
  final VoidCallback onImport;
  String? selectedArrowType;

  PaletteComponent({
    required this.onNodeSelected,
    required this.onExport,
    required this.onImport,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    const double padding = 20.0;
    const double shapeSize = 50.0;
    const double arrowSize = 80.0;
    const double buttonHeight = 40.0;
    const double buttonWidth = 80.0;
    const double buttonPadding = 10.0;
    const double gridSquareSize = 50.0; // Assuming grid square size is 50.0
    final Paint faintLinePaint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(100, 0), Offset(100, size.y), faintLinePaint);

    final double startY = padding;
    final double processY = startY + shapeSize + padding;
    final double decisionY = processY + shapeSize + padding;
    final double stopY = decisionY + shapeSize + padding;
    final double arrowY = stopY + shapeSize + padding;

    final startPaint = Paint()..color = const Color(0xFF4CAF50);
    canvas.drawCircle(Offset(50, startY + shapeSize / 2), shapeSize / 2, startPaint);

    final processPaint = Paint()..color = const Color(0xFF2196F3);
    canvas.drawRect(Rect.fromLTWH(25, processY, shapeSize, shapeSize), processPaint);

    final decisionPaint = Paint()..color = const Color(0xFFFFEB3B);
    Path diamondPath = Path();
    diamondPath.moveTo(50, decisionY);
    diamondPath.lineTo(25, decisionY + shapeSize / 2);
    diamondPath.lineTo(50, decisionY + shapeSize);
    diamondPath.lineTo(75, decisionY + shapeSize / 2);
    diamondPath.close();
    canvas.drawPath(diamondPath, decisionPaint);

    final stopPaint = Paint()..color = const Color(0xFFF44336);
    canvas.drawCircle(Offset(50, stopY + shapeSize / 2), shapeSize / 2, stopPaint);

    // Pass Arrow: Green Arrow
    final arrowPaint = Paint()
      ..color = selectedArrowType == 'pass_arrow' ? Colors.green.withOpacity(0.6) : Colors.green;
    Path arrowPath = Path();
    arrowPath.moveTo(20, arrowY + arrowSize / 2);
    arrowPath.lineTo(20 + arrowSize, arrowY + arrowSize / 2);
    arrowPath.lineTo(20 + arrowSize - 20, arrowY + arrowSize / 2 - 10);
    arrowPath.moveTo(20 + arrowSize, arrowY + arrowSize / 2);
    arrowPath.lineTo(20 + arrowSize - 20, arrowY + arrowSize / 2 + 10);
    canvas.drawPath(arrowPath, arrowPaint);

    // Fail Arrow: Red Arrow (Adjusted Y-Position)
    final failArrowPaint = Paint()
      ..color = selectedArrowType == 'fail_arrow' ? Colors.red.withOpacity(0.6) : Colors.red;
    Path failArrowPath = Path();
    final double adjustedArrowY = arrowY - gridSquareSize; // Adjust Y-position by grid square size
    failArrowPath.moveTo(20, adjustedArrowY + arrowSize + arrowSize / 2);
    failArrowPath.lineTo(20 + arrowSize, adjustedArrowY + arrowSize + arrowSize / 2);
    failArrowPath.lineTo(20 + arrowSize - 20, adjustedArrowY + arrowSize + arrowSize / 2 - 10);
    failArrowPath.moveTo(20 + arrowSize, adjustedArrowY + arrowSize + arrowSize / 2);
    failArrowPath.lineTo(20 + arrowSize - 20, adjustedArrowY + arrowSize + arrowSize / 2 + 10);
    canvas.drawPath(failArrowPath, failArrowPaint);

    // Render Export button
    final exportButtonPaint = Paint()..color = Colors.blueAccent;
    final Rect exportButtonRect = Rect.fromLTWH(
        10, arrowY + arrowSize + 2 * padding + buttonHeight, buttonWidth, buttonHeight);
    canvas.drawRRect(RRect.fromRectAndRadius(exportButtonRect, Radius.circular(10)), exportButtonPaint);

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'Export',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(exportButtonRect.left + 15, exportButtonRect.top + 8));

    // Render Import button
    final importButtonPaint = Paint()..color = Colors.blueAccent;
    final Rect importButtonRect = Rect.fromLTWH(
        10, arrowY + arrowSize + 2 * padding + 2 * buttonHeight + buttonPadding, buttonWidth, buttonHeight);
    canvas.drawRRect(RRect.fromRectAndRadius(importButtonRect, Radius.circular(10)), importButtonPaint);

    textPainter.text = TextSpan(
      text: 'Import',
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(importButtonRect.left + 15, importButtonRect.top + 8));
  }

  bool handleTap(Offset position) {
    const double padding = 20.0;
    const double shapeSize = 50.0;
    const double arrowSize = 80.0;
    const double buttonHeight = 40.0;
    const double buttonWidth = 80.0;
    const double buttonPadding = 10.0;
    const double gridSquareSize = 50.0; // Assuming grid square size is 50.0

    final adjustedPosition = Offset(position.dx, position.dy - 40);

    final double startY = padding;
    final double processY = startY + shapeSize + padding;
    final double decisionY = processY + shapeSize + padding;
    final double stopY = decisionY + shapeSize + padding;
    final double arrowY = stopY + shapeSize + padding;
    final double adjustedArrowY = arrowY - gridSquareSize;

    if ((adjustedPosition - Offset(50, startY + shapeSize / 2)).distance < shapeSize / 2) {
      onNodeSelected('start', adjustedPosition);
      return true;
    } else if (Rect.fromLTWH(25, processY, shapeSize, shapeSize).contains(adjustedPosition)) {
      onNodeSelected('process', adjustedPosition);
      return true;
    } else if (Rect.fromLTWH(25, decisionY, shapeSize, shapeSize).contains(adjustedPosition)) {
      onNodeSelected('decision', adjustedPosition);
      return true;
    } else if ((adjustedPosition - Offset(50, stopY + shapeSize / 2)).distance < shapeSize / 2) {
      onNodeSelected('stop', adjustedPosition);
      return true;
    } else if (Rect.fromLTWH(20, arrowY + arrowSize / 2 - 10, arrowSize, 20).contains(adjustedPosition)) {
      selectedArrowType = 'pass_arrow';
      onNodeSelected('pass_arrow', adjustedPosition);
      return true;
    } else if (Rect.fromLTWH(20, adjustedArrowY + arrowSize + arrowSize / 2 - 10, arrowSize, 20).contains(adjustedPosition)) {
      selectedArrowType = 'fail_arrow';
      onNodeSelected('fail_arrow', adjustedPosition);
      return true;
    } else if (Rect.fromLTWH(10, arrowY + arrowSize + 2 * padding + buttonHeight, buttonWidth, buttonHeight).contains(adjustedPosition)) {
      onExport();
      return true;
    } else if (Rect.fromLTWH(10, arrowY + arrowSize + 2 * padding + 2 * buttonHeight + buttonPadding, buttonWidth, buttonHeight).contains(adjustedPosition)) {
      onImport();
      return true;
    }
    return false;
  }

  void updateSelectedArrowType(String? type) {
    selectedArrowType = type;
    // The component will automatically update in the next render cycle
  }

  @override
  void update(double dt) {
    super.update(dt);
    // No need to manually force a redraw; it will naturally happen during the next render cycle
  }
}