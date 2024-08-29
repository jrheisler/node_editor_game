import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'node.dart';
import 'arrow_component.dart';
import 'palette_component.dart';

class NodeEditorGame extends FlameGame {
  SimpleNode? selectedNode;
  Vector2? lastDragPosition;
  ArrowComponent? draggingArrow;
  late PaletteComponent palette;
  String? selectedArrowType;
  double gridSize = 50.0;

  @override
  Future<void> onLoad() async {
    palette = PaletteComponent(onNodeSelected: (String type, Offset position) {
      if (type.contains("arrow")) {
        selectArrowType(type);
      } else {
        createNode(position, type); // Create a new node when selected from the palette
      }
    });

    add(palette);
  }

  void selectArrowType(String type) {
    selectedArrowType = type; // Store the selected arrow type
    draggingArrow = null; // Reset any ongoing arrow drag
    palette.updateSelectedArrowType(selectedArrowType); // Update the palette
    print("Arrow type selected: $type. Please click on a node to start dragging the arrow.");
  }

  @override
  void handleTap(Offset tapPosition) {
    final position = Vector2(tapPosition.dx, tapPosition.dy - 40); // Adjust for toolbar height

    if (palette.handleTap(tapPosition)) {
      return;
    }

    // Handle arrow dragging or node selection
    if (selectedArrowType != null && draggingArrow == null) {
      selectedNode = findNodeAt(position);
      if (selectedNode != null) {
        // Start dragging an arrow from the first selected node
        final color = selectedArrowType == "pass_arrow" ? Colors.green : Colors.red;
        draggingArrow = ArrowComponent(
          startNode: selectedNode!,
          endNode: selectedNode!, // Temporarily the same, will be updated when the second node is selected
          color: color,
        );
        print("Arrow started from node at position: ${draggingArrow!.startNode.position}");
      }
    } else if (draggingArrow != null) {
      selectedNode = findNodeAt(position);
      if (selectedNode != null && draggingArrow!.startNode != selectedNode) {
        // Finalize the arrow connection to the second node
        draggingArrow!.endNode = selectedNode!;
        add(draggingArrow!); // Add the finalized arrow to the canvas
        print("Arrow ended at node at position: ${draggingArrow!.endNode.position}");
        selectedArrowType = null; // Reset arrow type selection
        draggingArrow = null; // Arrow dragging is done
        palette.updateSelectedArrowType(null); // Reset palette highlight
      }
    } else {
      // Handle node selection or dragging
      selectedNode = findNodeAt(position);
      if (selectedNode != null) {
        lastDragPosition = position;
        print("Node selected for dragging at position: ${selectedNode!.position}");
      } else {
        print("No node selected.");
      }
    }
  }

  @override
  void handleDrag(Offset newPosition) {
    if (draggingArrow != null) {
      // Update the dragging arrow's end position to follow the cursor
      draggingArrow!.endNode.position = Vector2(newPosition.dx, newPosition.dy - 40); // Adjust for toolbar height
    } else if (selectedNode != null && lastDragPosition != null) {
      // Dragging a node
      final newDragPosition = Vector2(newPosition.dx, newPosition.dy - 40); // Adjust for toolbar height
      final delta = newDragPosition - lastDragPosition!;
      selectedNode!.position.add(delta);
      lastDragPosition = newDragPosition;

      // No need to call markNeedsPaint; the arrow will automatically update
      print("Node dragged to: ${selectedNode!.position}");
    } else {
      print("No node is selected for dragging");
    }
  }

  @override
  void endDrag() {
    if (draggingArrow != null) {
      // Finalize arrow drawing without snapping the node to the grid
      print("Arrow drawing finalized.");
    } else if (selectedNode != null) {
      snapNodeToGrid(selectedNode!);
      selectedNode = null;
      lastDragPosition = null;
      print("Node dragging ended");
    }
  }

  void cancelArrowDrawing() {
    if (draggingArrow != null) {
      remove(draggingArrow!);
      draggingArrow = null;
      selectedArrowType = null;
      palette.updateSelectedArrowType(null); // Reset palette highlight
      print("Arrow drawing canceled.");
    }
  }

  SimpleNode? findNodeAt(Vector2 position) {
    for (final component in children) {
      if (component is SimpleNode && component.containsPoint(position)) {
        return component;
      }
    }
    return null;
  }

  void snapNodeToGrid(SimpleNode node) {
    final double paletteWidth = 100.0; // Assuming the palette is 100 pixels wide

    // Check if the node is outside the palette area
    if (node.position.x > paletteWidth) {
      final double adjustedX = node.position.x - paletteWidth; // Adjust by the palette width
      final double snappedX = (adjustedX / gridSize).round() * gridSize + paletteWidth;
      final double snappedY = (node.position.y / gridSize).round() * gridSize;
      node.position = Vector2(snappedX, snappedY);
      print("Node snapped to grid at position: ${node.position}");
    } else {
      print("Node not snapped to grid as it is within the palette area.");
    }
  }

  void createNode(Offset position, String type) {
    Vector2 nodePosition = Vector2(position.dx, position.dy - 40); // Adjust for toolbar height
    SimpleNode newNode;

    if (type == "start") {
      newNode = SimpleNode(
        position: nodePosition,
        size: Vector2(gridSize, gridSize), // Use gridSize here
        color: Colors.green,
        shape: "circle",
        editorGame: this,
      );
    } else if (type == "process") {
      newNode = SimpleNode(
        position: nodePosition,
        size: Vector2(gridSize, gridSize), // Use gridSize here
        color: Colors.blue,
        shape: "square",
        editorGame: this,
      );
    } else if (type == "decision") {
      newNode = SimpleNode(
        position: nodePosition,
        size: Vector2(gridSize, gridSize), // Use gridSize here
        color: Colors.yellow,
        shape: "diamond",
        editorGame: this,
      );
    } else if (type == "stop") {
      newNode = SimpleNode(
        position: nodePosition,
        size: Vector2(gridSize, gridSize), // Use gridSize here
        color: Colors.red,
        shape: "circle",
        editorGame: this,
      );
    } else {
      newNode = SimpleNode(
        position: nodePosition,
        size: Vector2(gridSize, gridSize), // Use gridSize here
        color: Colors.red,
        shape: "circle",
        editorGame: this,
      );
    }

    add(newNode);
    selectedNode = newNode; // Immediately set the new node as selected for dragging
    lastDragPosition = nodePosition;
    print("Node created and ready for dragging: $type");
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw grid lines only on the canvas, not on the palette
    final Paint gridPaint = Paint()
      ..color = const Color(0xFFCCCCCC).withOpacity(0.3) // Set opacity to 30%
      ..strokeWidth = 1.0;

    // Define the canvas area, excluding the palette
    const double paletteWidth = 100; // Assuming the palette is 100 pixels wide
    final double canvasStartX = paletteWidth; // Grid starts after the palette
    final canvasSize = size.toSize();

    for (double x = canvasStartX; x < canvasSize.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, canvasSize.height), gridPaint);
    }

    for (double y = 0; y < canvasSize.height; y += gridSize) {
      canvas.drawLine(
          Offset(canvasStartX, y), Offset(canvasSize.width, y), gridPaint);
    }
  }

  void updateGridSize(double newSize) {
    gridSize = newSize;

    // Snap all nodes to the new grid size
    for (final component in children) {
      if (component is SimpleNode) {
        snapNodeToGrid(component);
        component.size =
            Vector2(gridSize, gridSize); // Resize nodes to match grid size
      }
    }

    print('Grid size updated to: $gridSize');
  }


}