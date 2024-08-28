import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'node.dart';
import 'palette_component.dart';

class NodeEditorGame extends FlameGame {
  SimpleNode? selectedNode;
  Vector2? lastDragPosition;
  late PaletteComponent palette;

  @override
  Future<void> onLoad() async {
    palette = PaletteComponent(onNodeSelected: (String type, Offset position) {
      createNode(Vector2(position.dx, position.dy), type);
    });

    add(palette);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw grid lines only on the canvas, not on the palette
    const double gridSize = 50.0;
    final Paint gridPaint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 1.0;

    // Define the canvas area, excluding the palette
    final double paletteWidth = 100;  // Assuming the palette is 100 pixels wide
    final double canvasStartX = paletteWidth;  // Grid starts after the palette
    final canvasSize = size.toSize();

    for (double x = canvasStartX; x < canvasSize.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, canvasSize.height), gridPaint);
    }

    for (double y = 0; y < canvasSize.height; y += gridSize) {
      canvas.drawLine(Offset(canvasStartX, y), Offset(canvasSize.width, y), gridPaint);
    }
  }

  void handleTap(Offset tapPosition) {
    final position = Vector2(tapPosition.dx, tapPosition.dy);

    // Check if the tap is within the palette first
    if (palette.handleTap(tapPosition)) {
      return;
    }

    // Check if a node is tapped and select it for dragging
    bool nodeSelected = false;
    for (final component in children) {
      if (component is SimpleNode && component.containsPoint(position)) {
        selectedNode = component;
        lastDragPosition = position;
        nodeSelected = true;
        print('Node selected for dragging at position: ${selectedNode!.position}');
        break;
      }
    }

    if (!nodeSelected) {
      print('No node was selected for dragging');
    }
  }

  void handleDrag(Offset newPosition) {
    if (selectedNode != null && lastDragPosition != null) {
      final newDragPosition = Vector2(newPosition.dx, newPosition.dy);
      final delta = newDragPosition - lastDragPosition!;
      selectedNode!.position.add(delta);
      lastDragPosition = newDragPosition;
      print('Node dragged to: ${selectedNode!.position}');
    } else {
      print('No node is selected for dragging');
    }
  }

  void endDrag() {
    if (selectedNode != null) {
      print('Drag ended for node at position: ${selectedNode!.position}');
    } else {
      print('Drag ended with no node selected');
    }
    selectedNode = null;
    lastDragPosition = null;
  }

  void createNode(Vector2 position, String type) {
    SimpleNode newNode;
    if (type == 'start') {
      newNode = SimpleNode(
        position: position,
        size: Vector2(50, 50),
        color: Colors.green,
        shape: 'circle',
      );
    } else if (type == 'process') {
      newNode = SimpleNode(
        position: position,
        size: Vector2(50, 50),
        color: Colors.blue,
        shape: 'square',
      );
    } else if (type == 'decision') {
      newNode = SimpleNode(
        position: position,
        size: Vector2(50, 50),
        color: Colors.yellow,
        shape: 'diamond',
      );
    } else if (type == 'stop') {
      newNode = SimpleNode(
        position: position,
        size: Vector2(50, 50),
        color: Colors.red,
        shape: 'circle',
      );
    } else {
      newNode = SimpleNode(
        position: position,
        size: Vector2(50, 50),
        color: Colors.red,
        shape: 'circle',
      );
    }

    add(newNode);
    selectedNode = newNode;
    lastDragPosition = position;
    print('Node created and ready for dragging: $type');
  }
}
