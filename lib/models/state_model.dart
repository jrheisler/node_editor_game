import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:node_editor_game/models/process_model.dart';
import 'package:vector_math/vector_math_64.dart';

class NodeEditorState {
  List<SimpleNodeState> nodes;
  List<ArrowComponentState> arrows;
  String? selectedArrowType;
  double gridSize;
  String? selectedNodeUuid;
  Vector2? lastDragPosition;
  List<ProcessData> processes;

  NodeEditorState({
    required this.nodes,
    required this.arrows,
    this.selectedArrowType,
    required this.gridSize,
    this.selectedNodeUuid,
    this.lastDragPosition,
    required this.processes,
  });

  factory NodeEditorState.fromJson(Map<String, dynamic> json) {
    return NodeEditorState(
      nodes: (json['nodes'] as List).map((e) => SimpleNodeState.fromJson(e)).toList(),
      arrows: (json['arrows'] as List).map((e) => ArrowComponentState.fromJson(e)).toList(),
      selectedArrowType: json['selectedArrowType'],
      gridSize: json['gridSize'],
      selectedNodeUuid: json['selectedNodeUuid'],
      lastDragPosition: json['lastDragPosition'] != null
          ? Vector2(json['lastDragPosition'][0], json['lastDragPosition'][1])
          : null,
      processes: (json['processes'] as List).map((e) => ProcessData.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((e) => e.toJson()).toList(),
      'arrows': arrows.map((e) => e.toJson()).toList(),
      'selectedArrowType': selectedArrowType,
      'gridSize': gridSize,
      'selectedNodeUuid': selectedNodeUuid,
      'lastDragPosition': lastDragPosition != null
          ? [lastDragPosition!.x, lastDragPosition!.y]
          : null,
      'processes': processes.map((e) => e.toJson()).toList(),
    };
  }
}

class SimpleNodeState {
  final Color color;
  final String shape;
  final String uuid;
  final Vector2 position;
  final Vector2 size;

  SimpleNodeState({
    required this.color,
    required this.shape,
    required this.uuid,
    required this.position,
    required this.size,
  });

  factory SimpleNodeState.fromJson(Map<String, dynamic> json) {
    return SimpleNodeState(
      color: Color(json['color']),
      shape: json['shape'],
      uuid: json['uuid'],
      position: Vector2(json['position'][0], json['position'][1]), // Assuming [x, y] format
      size: Vector2(json['size'][0], json['size'][1]), // Assuming [x, y] format
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color.value,
      'shape': shape,
      'uuid': uuid,
      'position': [position.x, position.y],  // Convert Vector2 to a list
      'size': [size.x, size.y],  // Convert Vector2 to a list
    };
  }
}

class ArrowComponentState {
  final String startNodeUuid;
  final String endNodeUuid;
  final Color color;
  final double arrowHeadSize;

  ArrowComponentState({
    required this.startNodeUuid,
    required this.endNodeUuid,
    required this.color,
    this.arrowHeadSize = 10.0,
  });

  // Factory constructor to create an instance from JSON
  factory ArrowComponentState.fromJson(Map<String, dynamic> json) {
    return ArrowComponentState(
      startNodeUuid: json['startNodeUuid'],
      endNodeUuid: json['endNodeUuid'],
      color: Color(json['color']),
      arrowHeadSize: json['arrowHeadSize'],
    );
  }

  // Method to serialize the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'startNodeUuid': startNodeUuid,
      'endNodeUuid': endNodeUuid,
      'color': color.value,
      'arrowHeadSize': arrowHeadSize,
    };
  }
}
