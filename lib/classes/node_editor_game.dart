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
    palette = PaletteComponent(onNodeSelected: (nodeType) {
      createNode(Vector2(100, 100), nodeType);
    });

    add(palette);
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
    if (type == 'start') {
      final startNode = SimpleNode(
        position: position,
        size: Vector2(50, 50), // Same size as on the palette
        color: Colors.green,
        shape: 'circle',
      );
      add(startNode);
    } else if (type == 'process') {
      final processNode = SimpleNode(
        position: position,
        size: Vector2(50, 50), // Same size as on the palette
        color: Colors.blue,
        shape: 'square',
      );
      add(processNode);
    } else if (type == 'decision') {
      final decisionNode = SimpleNode(
        position: position,
        size: Vector2(50, 50), // Same size as on the palette
        color: Colors.yellow,
        shape: 'diamond',
      );
      add(decisionNode);
    } else if (type == 'stop') {
      final stopNode = SimpleNode(
        position: position,
        size: Vector2(50, 50), // Same size as on the palette
        color: Colors.red,
        shape: 'circle',
      );
      add(stopNode);
    }
  }

}
