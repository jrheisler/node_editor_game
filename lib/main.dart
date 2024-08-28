import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'classes/node_editor_game.dart';


void main() {
  final game = NodeEditorGame();

  runApp(
    GestureDetector(
      onTapDown: (TapDownDetails details) {
        final tapPosition = details.globalPosition;
        game.handleTap(tapPosition);
      },
      onPanUpdate: (DragUpdateDetails details) {
        game.handleDrag(details.globalPosition);
      },
      onPanEnd: (DragEndDetails details) {
        game.endDrag();
      },
      child: GameWidget(game: game),
    ),
  );
}
