import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:uuid/uuid.dart';
import 'classes/node.dart';
import 'classes/node_editor_game.dart';
import 'models/process_model.dart';


String version = '0.1';

void main() {
  runApp(NodeEditorApp());
}

class NodeEditorApp extends StatefulWidget {
  @override
  _NodeEditorAppState createState() => _NodeEditorAppState();
}

class _NodeEditorAppState extends State<NodeEditorApp> {
  final NodeEditorGame game = NodeEditorGame();
  bool isDialogVisible = false;
  late SimpleNode chosenNode;
  late ProcessData chosenProcess;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chosenNode = SimpleNode(
      position: Vector2(0, 0),
      size: Vector2(0, 0),
      color: Colors.transparent,
      shape: "circle",
      editorGame: game,
      uuid: const Uuid().v4(),
    );
    chosenProcess = ProcessData(id: chosenNode.uuid);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Process Editor v $version',
      home: Column(
        children: [
          // Custom Row acting as a toolbar, wrapped with Material
          Material(
            elevation: 2.0,
            // Optional: adds shadow for better visual distinction
            child: Container(
              height: 40.0,
              color: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const Text(
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
                          game.updateGridSize(
                              value); // Update the grid size in the game
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
              onDoubleTapDown: (TapDownDetails details) {
                setState(() {
                  final position = Vector2(
                      details.localPosition.dx, details.localPosition.dy);
                  // Check if a node was double-tapped

                  for (final component in game.children) {
                    if (component is SimpleNode &&
                        component.containsPoint(position)) {
                      isDialogVisible = true;
                      //print('97 ${component.uuid}');

                      chosenProcess = game.processes.firstWhere(
                            (process) => process.id == component.uuid,
                        orElse: () => ProcessData(id: component.uuid, name: "Unknown Process"),
                      );

                      chosenNode = component;
                      break;
                    }
                  }
                });
              },
              child: Stack(children: [
                GameWidget(game: game),
                if (isDialogVisible)
                  Center(
                    child: //chosenNode.showNodeDialog(context)
                        AlertDialog(
                      title: const Text('Edit Node'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            onChanged: (value) {
                              chosenProcess.name = value;
                            },
                            controller: TextEditingController(
                                text: '${chosenProcess.name}'),
                          ),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: 'Description'),
                            onChanged: (value) {
                              chosenProcess.desc = value;
                            },
                            controller: TextEditingController(
                                text: '${chosenProcess.desc}'),
                          ),
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isDialogVisible = false;
                              chosenNode.delete();
                            });
                          },
                          child: const Text('Delete Node'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isDialogVisible = false;
                              chosenNode.deleteAttachedArrows();
                            });
                          },
                          child: const Text('Delete Attached Arrows'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              int index = game.processes.indexWhere((process) => process.id == chosenProcess.id);

                              if (index != -1) {
                                // Replace the object at the found index
                                game.processes[index] = chosenProcess;
                                //print('Process replaced successfully.');
                              } else {
                                //print('${chosenProcess.id}');
                                //game.processes.forEach((element) => print(element.id));
                                game.processes.add(chosenProcess);
                                //print('Process not found.');
                              }

                              isDialogVisible = false;
                            });
                          },
                          child: const Text('Save'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isDialogVisible = false;
                            });
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
