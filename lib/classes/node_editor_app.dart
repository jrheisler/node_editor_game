import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:uuid/uuid.dart';
import '../models/process_model.dart';
import 'node.dart';
import 'node_editor_game.dart';

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
    return Column(children: [
      Material(
        elevation: 2.0,
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
                      game.updateGridSize(value);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            final tapPosition = details.globalPosition;
            game.handleTap(tapPosition);
          },
          onPanUpdate: (DragUpdateDetails details) {
            print('137 pan');
            game.handleDrag(details.globalPosition);
          },
          onPanEnd: (DragEndDetails details) {
            print('141 endPan');
            game.endDrag();
          },
          onDoubleTapDown: (TapDownDetails details) {
            setState(() {
              final position =
                  Vector2(details.localPosition.dx, details.localPosition.dy);

              for (final component in game.children) {
                if (component is SimpleNode &&
                    component.containsPoint(position)) {
                  isDialogVisible = true;

                  chosenProcess = game.processes.firstWhere(
                    (process) => process.id == component.uuid,
                    orElse: () => ProcessData(
                        id: component.uuid, name: "Unknown Process"),
                  );

                  chosenNode = component;
                  break;
                }
              }
            });
          },
          child: Stack(
            children: [
              GameWidget(game: game),
              if (isDialogVisible)
                Center(
                  child: AlertDialog(
                    title: const Text('Edit Process Data'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                              onChanged: (value) {
                                chosenProcess.name =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.name ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Description'),
                              maxLines: null,
                              minLines: 4,
                              onChanged: (value) {
                                chosenProcess.desc =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.desc ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Process Owner'),
                              onChanged: (value) {
                                chosenProcess.processOwner =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.processOwner ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Estimated Cycle Time'),
                              onChanged: (value) {
                                chosenProcess.estCycleTime =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.estCycleTime ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Estimated Cycle Type'),
                              onChanged: (value) {
                                chosenProcess.estCycleType =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.estCycleType ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Owner Email'),
                              onChanged: (value) {
                                chosenProcess.ownerEmail =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.ownerEmail ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Owner'),
                              onChanged: (value) {
                                chosenProcess.owner =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.owner ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Created By'),
                              onChanged: (value) {
                                chosenProcess.createdBy =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.createdBy ?? " "),
                            ),
                            DateTimeField(
                              initialDate:
                                  chosenProcess.dateCreated ?? DateTime.now(),
                              label: 'Date Created',
                              onDateSelected: (DateTime value) {
                                chosenProcess.dateCreated = value;
                              },
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Change From'),
                              onChanged: (value) {
                                chosenProcess.changeFrom =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.changeFrom ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Process Type'),
                              onChanged: (value) {
                                chosenProcess.processType =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.processType ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Status'),
                              onChanged: (value) {
                                chosenProcess.status =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.status ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Process Step'),
                              onChanged: (value) {
                                chosenProcess.processStep =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.processStep ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Used On Count'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                chosenProcess.usedOnCount =
                                    num.tryParse(value) ?? 0;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.usedOnCount?.toString() ??
                                      "0"),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Revision'),
                              onChanged: (value) {
                                chosenProcess.rev = value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.rev ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Version'),
                              onChanged: (value) {
                                chosenProcess.ver = value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.ver ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Iteration'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                chosenProcess.iteration =
                                    num.tryParse(value) ?? 0;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.iteration?.toString() ??
                                      "0"),
                            ),
                            DateTimeField(
                              initialDate:
                                  chosenProcess.createDate ?? DateTime.now(),
                              label: 'Create Date',
                              onDateSelected: (DateTime value) {
                                chosenProcess.createDate = value;
                              },
                            ),

                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Day'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                chosenProcess.day = num.tryParse(value) ?? 0;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.day?.toString() ?? "0"),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Hour'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                chosenProcess.hour = num.tryParse(value) ?? 0;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.hour?.toString() ?? "0"),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Minute'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                chosenProcess.minute = num.tryParse(value) ?? 0;
                              },
                              controller: TextEditingController(
                                  text:
                                      chosenProcess.minute?.toString() ?? "0"),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Start Day'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                chosenProcess.startDay =
                                    num.tryParse(value) ?? 0;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.startDay?.toString() ??
                                      "0"),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'UDF1'),
                              onChanged: (value) {
                                chosenProcess.udf1 =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.udf1 ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'UDF2'),
                              onChanged: (value) {
                                chosenProcess.udf2 =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.udf2 ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'UDF3'),
                              onChanged: (value) {
                                chosenProcess.udf3 =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.udf3 ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'UDF4'),
                              onChanged: (value) {
                                chosenProcess.udf4 =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.udf4 ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'UDF5'),
                              onChanged: (value) {
                                chosenProcess.udf5 =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.udf5 ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'UDF6'),
                              onChanged: (value) {
                                chosenProcess.udf6 =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.udf6 ?? " "),
                            ),
                            SwitchListTile(
                              title: const Text('UDF7'),
                              value: chosenProcess.udf7 ?? false,
                              onChanged: (bool value) {
                                setState(() {
                                  chosenProcess.udf7 = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              title: const Text('UDF8'),
                              value: chosenProcess.udf8 ?? false,
                              onChanged: (bool value) {
                                setState(() {
                                  chosenProcess.udf8 = value;
                                });
                              },
                            ),
                            DateTimeField(
                              initialDate: chosenProcess.udf9 ?? DateTime.now(),
                              label: 'UDF9',
                              onDateSelected: (DateTime value) {
                                chosenProcess.udf9 = value;
                              },
                            ),
                            DateTimeField(
                              initialDate:
                                  chosenProcess.udf10 ?? DateTime.now(),
                              label: 'UDF10',
                              onDateSelected: (DateTime value) {
                                chosenProcess.udf10 = value;
                              },
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Resource ID'),
                              onChanged: (value) {
                                chosenProcess.resourceId =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.resourceId ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Build State'),
                              onChanged: (value) {
                                chosenProcess.buildState =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.buildState ?? " "),
                            ),
                            DateTimeField(
                              initialDate:
                                  chosenProcess.startBuild ?? DateTime.now(),
                              label: 'Start Build',
                              onDateSelected: (DateTime value) {
                                chosenProcess.startBuild = value;
                              },
                            ),
                            DateTimeField(
                              initialDate:
                                  chosenProcess.endBuild ?? DateTime.now(),
                              label: 'End Build',
                              onDateSelected: (DateTime value) {
                                chosenProcess.endBuild = value;
                              },
                            ),
                            DateTimeField(
                              initialDate:
                                  chosenProcess.releaseDate ?? DateTime.now(),
                              label: 'Release Date',
                              onDateSelected: (DateTime value) {
                                chosenProcess.releaseDate = value;
                              },
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Build Notes'),
                              onChanged: (value) {
                                chosenProcess.buildNotes =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.buildNotes ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Version'),
                              onChanged: (value) {
                                chosenProcess.version =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.version ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Estimated Cost'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                chosenProcess.estCost =
                                    double.tryParse(value) ?? 0.0;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.estCost?.toString() ??
                                      "0.0"),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Image'),
                              onChanged: (value) {
                                chosenProcess.image =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.image ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Vault'),
                              onChanged: (value) {
                                chosenProcess.vault =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.vault ?? " "),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Vault File Name'),
                              onChanged: (value) {
                                chosenProcess.vaultFileName =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.vaultFileName ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'URL'),
                              onChanged: (value) {
                                chosenProcess.url = value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.url ?? " "),
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'URL Label'),
                              onChanged: (value) {
                                chosenProcess.urlLabel =
                                    value.isEmpty ? " " : value;
                              },
                              controller: TextEditingController(
                                  text: chosenProcess.urlLabel ?? " "),
                            ),
                            DateTimeField(
                              initialDate:
                                  chosenProcess.dueDate ?? DateTime.now(),
                              label: 'Due Date',
                              onDateSelected: (DateTime value) {
                                chosenProcess.dueDate = value;
                              },
                            ),
                          ],
                        ),
                      ),
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
                            int index = game.processes.indexWhere(
                                (process) => process.id == chosenProcess.id);

                            if (index != -1) {
                              // Replace the object at the found index
                              game.processes[index] = chosenProcess;
                            } else {
                              game.processes.add(chosenProcess);
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
                )
            ],
          ),
        ),
      ),
    ]);
  }
}

class DateTimeField extends StatelessWidget {
  final DateTime initialDate;
  final String label;
  final Function(DateTime) onDateSelected;

  DateTimeField({
    required this.initialDate,
    required this.label,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label),
        ),
        TextButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
          child: Text('${initialDate.toLocal()}'.split(' ')[0]),
        ),
      ],
    );
  }
}
