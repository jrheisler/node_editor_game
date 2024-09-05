import 'dart:html' as html;
import 'dart:convert';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:node_editor_game/models/process_model.dart';
import 'package:uuid/uuid.dart';
import '../models/state_model.dart';
import '../services/download_file.dart';
import 'node.dart';
import 'arrow_component.dart';
import 'palette_component.dart';
import 'package:flame/components.dart';  // For CameraComponent and other game components
import 'package:flame/events.dart';  // For DragStartInfo, DragUpdateInfo, etc.

class NodeEditorGame extends FlameGame {
  SimpleNode? selectedNode;
  Vector2? lastDragPosition;
  ArrowComponent? draggingArrow;
  late PaletteComponent palette;
  String? selectedArrowType;
  double gridSize = 50.0;
  List<ProcessData> processes = [];
  List<SimpleNode> nodes = [];
  List<ArrowComponent> arrows = [];
  String? _savedState; // In-memory storage for demonstration purposes

  void saveEditorStateToLocalStorage() {
    String exportedState = exportNodeEditorState();
    _savedState = exportedState; // Save the state to a string variable
    downloadFile(_savedState!, 'Process Editor.json');
    print(_savedState);
  }

  void loadEditorStateFromLocalStorage() {
    if (_savedState != null) {
      restoreNodeEditorState(_savedState!);
      print('State restored.');
    } else {
      print('No saved state to load.');
    }
  }

  NodeEditorState captureCurrentState() {
    List<SimpleNodeState> nodesState =
        children.whereType<SimpleNode>().map((node) {
      return SimpleNodeState(
        color: node.color,
        shape: node.shape,
        uuid: node.uuid,
        position: node.position,
        size: node.size,
      );
    }).toList();

    List<ArrowComponentState> arrowsState =
        children.whereType<ArrowComponent>().map((arrow) {
      return ArrowComponentState(
        startNodeUuid: arrow.startNode.uuid,
        endNodeUuid: arrow.endNode.uuid,
        color: arrow.color,
      );
    }).toList();

    NodeEditorState state = NodeEditorState(
      nodes: nodesState,
      arrows: arrowsState,
      selectedArrowType: selectedArrowType,
      gridSize: gridSize,
      selectedNodeUuid: selectedNode?.uuid,
      lastDragPosition: lastDragPosition,
      processes: processes,
    );

    return state;
  }

  // Export the current state to a JSON string
  String exportNodeEditorState() {
    NodeEditorState currentState = captureCurrentState();
    return jsonEncode(currentState.toJson()); // Properly encode to JSON
  }

  // Restore the node editor state from a JSON string
  void restoreNodeEditorState(String jsonString) {
    try {
      Map<String, dynamic> stateJson = jsonDecode(jsonString);
      NodeEditorState restoredState = NodeEditorState.fromJson(stateJson);

      // Clear current nodes and arrows
      children.removeWhere((component) =>
          component is SimpleNode || component is ArrowComponent);

      // Rebuild nodes first and store them in a map for quick lookup
      final Map<String, SimpleNode> restoredNodes = {};
      for (var nodeState in restoredState.nodes) {
        SimpleNode newNode = SimpleNode(
          color: nodeState.color,
          shape: nodeState.shape,
          uuid: nodeState.uuid,
          position: nodeState.position,
          size: nodeState.size,
          editorGame: this,
        );
        add(newNode);
        restoredNodes[newNode.uuid] = newNode; // Store the node by its UUID
      }

      // Rebuild arrows after all nodes are added
      for (var arrowState in restoredState.arrows) {
        SimpleNode? startNode = restoredNodes[arrowState.startNodeUuid];
        SimpleNode? endNode = restoredNodes[arrowState.endNodeUuid];

        // Only add the arrow if both start and end nodes exist
        if (startNode != null && endNode != null) {
          ArrowComponent newArrow = ArrowComponent(
            startNode: startNode,
            endNode: endNode,
            color: arrowState.color,
          );
          add(newArrow);
        } else {
          print('Failed to restore arrow: one of the nodes was not found.');
        }
      }

      // Restore selected node if it exists
      selectedNode = restoredNodes[restoredState.selectedNodeUuid];

      // Restore other properties
      selectedArrowType = restoredState.selectedArrowType;
      gridSize = restoredState.gridSize;
      lastDragPosition = restoredState.lastDragPosition;
      processes = restoredState.processes;

      print('State restored.');
    } catch (e) {
      print('Failed to restore state: $e');
    }
  }

 /* // Example function to update the canvas
  void updateCanvas() {
    // Force a full update in the next game loop
    for (final component in children) {
      component.removeFromParent();
      add(component);
    }
  }*/

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Set a larger world size so that the camera can move


    // Add nodes or other elements to the game world here
    palette = PaletteComponent(
      onNodeSelected: (String type, Offset position) {
        if (type.contains("arrow")) {
          selectArrowType(type);
        } else {
          createNode(position,
              type); // Create a new node when selected from the palette
        }
      },
      onExport: () {
        saveEditorStateToLocalStorage();
      },
      onImport: () {
        // HTML input element
        html.InputElement uploadInput = html.FileUploadInputElement()
            as html.InputElement
          ..accept = '*/json';
        uploadInput.click();

        uploadInput.onChange.listen(
          (changeEvent) {
            final file = uploadInput.files!.first;
            final reader = html.FileReader();

            reader.readAsText(file);

            reader.onLoadEnd.listen(
                (loadEndEvent) async {
              var json = reader.result;
              _savedState = json.toString();
              loadEditorStateFromLocalStorage();
            });
          },
        );

      },
    );

    add(palette);
  }

  void selectArrowType(String type) {
    selectedArrowType = type; // Store the selected arrow type
    draggingArrow = null; // Reset any ongoing arrow drag
    palette.updateSelectedArrowType(selectedArrowType); // Update the palette
    print(
        "Arrow type selected: $type. Please click on a node to start dragging the arrow.");
  }

  @override
  void handleTap(Offset tapPosition) {
    final position = Vector2(
        tapPosition.dx, tapPosition.dy - 40); // Adjust for toolbar height

    if (palette.handleTap(tapPosition)) {
      return;
    }

    // Handle arrow dragging or node selection
    if (selectedArrowType != null && draggingArrow == null) {
      selectedNode = findNodeAt(position);
      if (selectedNode != null) {
        // Start dragging an arrow from the first selected node
        final color =
            selectedArrowType == "pass_arrow" ? Colors.green : Colors.red;
        draggingArrow = ArrowComponent(
          startNode: selectedNode!,
          endNode: selectedNode!,
          // Temporarily the same, will be updated when the second node is selected
          color: color,
        );
        print(
            "Arrow started from node at position: ${draggingArrow!.startNode.position}");
      }
    } else if (draggingArrow != null) {
      selectedNode = findNodeAt(position);
      if (selectedNode != null && draggingArrow!.startNode != selectedNode) {
        // Finalize the arrow connection to the second node
        draggingArrow!.endNode = selectedNode!;
        add(draggingArrow!); // Add the finalized arrow to the canvas
        print(
            "Arrow ended at node at position: ${draggingArrow!.endNode.position}");
        selectedArrowType = null; // Reset arrow type selection
        draggingArrow = null; // Arrow dragging is done
        palette.updateSelectedArrowType(null); // Reset palette highlight
      }
    } else {
      // Handle node selection or dragging
      selectedNode = findNodeAt(position);
      if (selectedNode != null) {
        lastDragPosition = position;
        print(
            "Node selected for dragging at position: ${selectedNode!.position}");
      } else {
        print("No node selected.");
      }
    }
  }

  @override
  void handleDrag(Offset newPosition) {
    if (draggingArrow != null) {
      // Update the dragging arrow's end position to follow the cursor
      draggingArrow!.endNode.position = Vector2(
          newPosition.dx, newPosition.dy - 40); // Adjust for toolbar height
    } else if (selectedNode != null && lastDragPosition != null) {
      // Dragging a node
      final newDragPosition = Vector2(
          newPosition.dx, newPosition.dy - 40); // Adjust for toolbar height
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

  /*void cancelArrowDrawing() {
    if (draggingArrow != null) {
      remove(draggingArrow!);
      draggingArrow = null;
      selectedArrowType = null;
      palette.updateSelectedArrowType(null); // Reset palette highlight
      print("Arrow drawing canceled.");
    }
  }*/

  SimpleNode? findNodeAt(Vector2 position) {
    for (final component in children) {
      if (component is SimpleNode && component.containsPoint(position)) {
        return component;
      }
    }
    return null;
  }

  void snapNodeToGrid(SimpleNode node) {
    final double paletteWidth =
        100.0; // Assuming the palette is 100 pixels wide

    // Check if the node is outside the palette area
    if (node.position.x > paletteWidth) {
      final double adjustedX =
          node.position.x - paletteWidth; // Adjust by the palette width
      final double snappedX =
          (adjustedX / gridSize).round() * gridSize + paletteWidth;
      final double snappedY = (node.position.y / gridSize).round() * gridSize;
      node.position = Vector2(snappedX, snappedY);
      print("Node snapped to grid at position: ${node.position}");
    } else {
      print("Node not snapped to grid as it is within the palette area.");
    }
  }

  void createNode(Offset position, String type) {
    Vector2 nodePosition =
        Vector2(position.dx, position.dy - 40); // Adjust for toolbar height
    SimpleNode newNode;

    if (type == "start") {
      newNode = SimpleNode(
        position: nodePosition,
        size: Vector2(gridSize, gridSize),
        // Use gridSize here
        color: Colors.green,
        shape: "circle",
        editorGame: this,
        uuid: const Uuid().v4(),
      );
    } else if (type == "process") {
      newNode = SimpleNode(
        position: nodePosition,
        size: Vector2(gridSize, gridSize),
        // Use gridSize here
        color: Colors.blue,
        shape: "square",
        editorGame: this,
        uuid: const Uuid().v4(),
      );
    } else if (type == "decision") {
      newNode = SimpleNode(
        position: nodePosition,
        size: Vector2(gridSize, gridSize),
        // Use gridSize here
        color: Colors.yellow,
        shape: "diamond",
        editorGame: this,
        uuid: const Uuid().v4(),
      );
    } else if (type == "stop") {
      newNode = SimpleNode(
        position: nodePosition,
        size: Vector2(gridSize, gridSize),
        // Use gridSize here
        color: Colors.red,
        shape: "circle",
        editorGame: this,
        uuid: const Uuid().v4(),
      );
    } else {
      newNode = SimpleNode(
        position: nodePosition,
        size: Vector2(gridSize, gridSize),
        // Use gridSize here
        color: Colors.red,
        shape: "circle",
        editorGame: this,
        uuid: const Uuid().v4(),
      );
    }

    add(newNode);
    selectedNode =
        newNode; // Immediately set the new node as selected for dragging
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
