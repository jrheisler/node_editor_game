import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'classes/node_editor_game.dart';

void main() {
  runApp(NodeEditorApp());
}

class NodeEditorApp extends StatefulWidget {
  @override
  _NodeEditorAppState createState() => _NodeEditorAppState();
}

class _NodeEditorAppState extends State<NodeEditorApp> {
  final NodeEditorGame game = NodeEditorGame();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: [
          // Custom Row acting as a toolbar, wrapped with Material
          Material(
            elevation: 2.0, // Optional: adds shadow for better visual distinction
            child: Container(
              height: 40.0,
              color: Colors.blueGrey,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    'Grid Size:',
                    style: TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                      value: game.gridSize,
                      min: 20.0,
                      max: 100.0,
                      divisions: 8,
                      label: game.gridSize.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          game.updateGridSize(value);  // Update the grid size in the game
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // The rest of the screen is the game
          Expanded(
            child: GestureDetector(
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
          ),
        ],
      ),
    );
  }
}
