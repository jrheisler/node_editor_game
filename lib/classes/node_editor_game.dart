import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'node.dart';
import 'palette_component.dart';

class NodeEditorGame extends FlameGame {
  SimpleNode? selectedNode;
  Vector2? lastDragPosition;
  late PaletteComponent palette;
  double gridSize = 50.0;

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
    final Paint gridPaint = Paint()
      ..color = const Color(0xFFCCCCCC).withOpacity(0.3)  // Set opacity to 30%
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

  void updateGridSize(double newSize) {
    gridSize = newSize;

    // Snap all nodes to the new grid size
    for (final component in children) {
      if (component is SimpleNode) {
        snapNodeToGrid(component);
        component.size = Vector2(gridSize, gridSize);  // Resize nodes to match grid size
      }
    }

    print('Grid size updated to: $gridSize');
  }


  void handleTap(Offset tapPosition) {
    final position = Vector2(tapPosition.dx, tapPosition.dy - 40); // Adjust for toolbar height

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
      final newDragPosition = Vector2(newPosition.dx, newPosition.dy - 40); // Adjust for toolbar height
      final delta = newDragPosition - lastDragPosition!;
      selectedNode!.position.add(delta);
      lastDragPosition = newDragPosition;

      // Only snap to grid when drag ends
      print('Node dragged to: ${selectedNode!.position}');
    } else {
      print('No node is selected for dragging');
    }
  }

  void endDrag() {
    if (selectedNode != null) {
      snapNodeToGrid(selectedNode!);
      print('Drag ended for node at position: ${selectedNode!.position}');
    } else {
      print('Drag ended with no node selected');
    }
    selectedNode = null;
    lastDragPosition = null;
  }

  void snapNodeToGrid(SimpleNode node) {
    final double paletteWidth = 100.0;  // Assuming the palette is 100 pixels wide

    // Check if the node is outside the palette area
    if (node.position.x > paletteWidth) {
      final double adjustedX = node.position.x - paletteWidth; // Adjust by the palette width
      final double snappedX = (adjustedX / gridSize).round() * gridSize + paletteWidth;
      final double snappedY = (node.position.y / gridSize).round() * gridSize;
      node.position = Vector2(snappedX, snappedY);
      print('Node snapped to grid at position: ${node.position}');
    } else {
      print('Node not snapped to grid as it is within the palette area.');
    }
  }


  void createNode(Vector2 position, String type) {
    SimpleNode newNode;
    if (type == 'start') {
      newNode = SimpleNode(
        position: position,
        size: Vector2(gridSize, gridSize),  // Use gridSize here
        color: Colors.green,
        shape: 'circle',
      );
    } else if (type == 'process') {
      newNode = SimpleNode(
        position: position,
        size: Vector2(gridSize, gridSize),  // Use gridSize here
        color: Colors.blue,
        shape: 'square',
      );
    } else if (type == 'decision') {
      newNode = SimpleNode(
        position: position,
        size: Vector2(gridSize, gridSize),  // Use gridSize here
        color: Colors.yellow,
        shape: 'diamond',
      );
    } else if (type == 'stop') {
      newNode = SimpleNode(
        position: position,
        size: Vector2(gridSize, gridSize),  // Use gridSize here
        color: Colors.red,
        shape: 'circle',
      );
    } else {
      newNode = SimpleNode(
        position: position,
        size: Vector2(gridSize, gridSize),  // Use gridSize here
        color: Colors.red,
        shape: 'circle',
      );
    }

    add(newNode);
    selectedNode = newNode;  // Immediately set the new node as selected for dragging
    lastDragPosition = position;
    print('Node created and ready for dragging: $type');
  }
}
