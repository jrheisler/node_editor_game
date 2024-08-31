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

    // Define the padding and spacing
    const double padding = 20.0;
    const double shapeSize = 50.0;
    const double arrowSize = 80.0; // Increased size for the arrows
    final Paint faintLinePaint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 2.0;

    // Draw the separating line to define the palette area
    canvas.drawLine(const Offset(100, 0), Offset(100, size.y), faintLinePaint);

    // Calculate positions for each node
    final double startY = padding;
    final double processY = startY + shapeSize + padding;
    final double decisionY = processY + shapeSize + padding;
    final double stopY = decisionY + shapeSize + padding;
    final double arrowY = stopY + shapeSize + padding;

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

    // Pass Arrow: Green Arrow
    final arrowPaint = Paint()
      ..color = selectedArrowType == 'pass_arrow' ? Colors.green.withOpacity(0.6) : Colors.green;
    Path arrowPath = Path();
    arrowPath.moveTo(20, arrowY + arrowSize / 2); // Start point of the arrow
    arrowPath.lineTo(20 + arrowSize, arrowY + arrowSize / 2); // Main arrow line
    arrowPath.lineTo(20 + arrowSize - 20, arrowY + arrowSize / 2 - 10); // Top arrowhead
    arrowPath.moveTo(20 + arrowSize, arrowY + arrowSize / 2); // Move back to the tip
    arrowPath.lineTo(20 + arrowSize - 20, arrowY + arrowSize / 2 + 10); // Bottom arrowhead
    canvas.drawPath(arrowPath, arrowPaint);

    // Fail Arrow: Red Arrow
    final failArrowPaint = Paint()
      ..color = selectedArrowType == 'fail_arrow' ? Colors.red.withOpacity(0.6) : Colors.red;
    Path failArrowPath = Path();
    failArrowPath.moveTo(20, arrowY + arrowSize + padding + arrowSize / 2); // Start point of the arrow
    failArrowPath.lineTo(20 + arrowSize, arrowY + arrowSize + padding + arrowSize / 2); // Main arrow line
    failArrowPath.lineTo(20 + arrowSize - 20, arrowY + arrowSize + padding + arrowSize / 2 - 10); // Top arrowhead
    failArrowPath.moveTo(20 + arrowSize, arrowY + arrowSize + padding + arrowSize / 2); // Move back to the tip
    failArrowPath.lineTo(20 + arrowSize - 20, arrowY + arrowSize + padding + arrowSize / 2 + 10); // Bottom arrowhead
    canvas.drawPath(failArrowPath, failArrowPaint);
    // Render Export and Import buttons
    TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: 'Export',
        style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(25, arrowY + arrowSize + 2 * padding));

    textPainter.text = const TextSpan(
      text: 'Import',
      style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 16),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(25, arrowY + arrowSize + 3 * padding));
  }

  bool handleTap(Offset position) {
    const double padding = 20.0;
    const double shapeSize = 50.0;
    const double arrowSize = 80.0;

    // Adjust for the toolbar height
    final adjustedPosition = Offset(position.dx, position.dy - 40);

    final double startY = padding;
    final double processY = startY + shapeSize + padding;
    final double decisionY = processY + shapeSize + padding;
    final double stopY = decisionY + shapeSize + padding;
    final double arrowY = stopY + shapeSize + padding;

    // Detect taps on each shape and trigger node creation or arrow drawing
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
    } else if (Rect.fromLTWH(20, arrowY + arrowSize + padding + arrowSize / 2 - 10, arrowSize, 20).contains(adjustedPosition)) {
      selectedArrowType = 'fail_arrow';
      onNodeSelected('fail_arrow', adjustedPosition);
      return true;
    } else if (Rect.fromLTWH(25, arrowY + arrowSize + 2 * padding, 50, 20).contains(adjustedPosition)) {
      onExport();
      return true;
    } else if (Rect.fromLTWH(25, arrowY + arrowSize + 3 * padding, 50, 20).contains(adjustedPosition)) {
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