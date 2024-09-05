import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:node_editor_game/models/add_ons.dart';
import 'package:uuid/uuid.dart';
import '../common/constants.dart';
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
  late AddOns currentAddOn;
  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController verticalScrollController = ScrollController();

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
    chosenProcess = ProcessData(id: chosenNode.uuid, addOns: [AddOns()]);
    currentAddOn = AddOns();
  }

  // Scroll the canvas by a specified amount
  void scrollCanvas(double dx, double dy) {
    // Scroll horizontally
    if (dx != 0) {
      horizontalScrollController.animateTo(
        horizontalScrollController.offset + dx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Scroll vertically
    if (dy != 0) {
      verticalScrollController.animateTo(
        verticalScrollController.offset + dy,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String saveOrAddOn = 'Save AddOn';
    return Column(children: [
      Material(
        elevation: 2.0,
        child: Container(
          height: 40.0,
          color: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              IconButton(
                  tooltip: 'Grid Home',
                  onPressed: () {
                    setState(() {
                      horizontalScrollController.jumpTo(0);
                      verticalScrollController.jumpTo(0);
                    });
                  },
                  icon: const Icon(Icons.home)),
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
            // Adjust the tap position relative to the current scroll offsets and canvas padding/margin
            final adjustedPosition = Offset(
              details.localPosition.dx + horizontalScrollController.offset,
              details.localPosition.dy +
                  verticalScrollController.offset +
                  game.gridSize, // Adjusting for grid offset
            );

            // Debugging output
            print('--- onTapDown ---${game.gridSize}');
            print('Original position: ${details.localPosition}');
            print(
                'Scroll offsets -> Horizontal: ${horizontalScrollController.offset}, Vertical: ${verticalScrollController.offset}');
            print('Adjusted position: $adjustedPosition');

            // Handle tap using the adjusted position
            game.handleTap(adjustedPosition);
          },
          onPanUpdate: (DragUpdateDetails details) {
            // Adjust the drag position relative to the current scroll offsets
            final adjustedPosition = Offset(
              details.localPosition.dx + horizontalScrollController.offset,
              details.localPosition.dy +
                  verticalScrollController.offset +
                  game.gridSize / 2, // Adjusting for grid offset
            );

            // Debugging output for drag
            print('--- onPanUpdate ---');
            print('Original drag position: ${details.localPosition}');
            print(
                'Scroll offsets -> Horizontal: ${horizontalScrollController.offset}, Vertical: ${verticalScrollController.offset}');
            print('Adjusted drag position: $adjustedPosition');

            // Handle drag using the adjusted position
            game.handleDrag(adjustedPosition);
          },
          onPanEnd: (DragEndDetails details) {
            // Debugging output for pan end
            print('--- onPanEnd ---');
            game.endDrag();
          },
          onDoubleTapDown: (TapDownDetails details) {
            setState(() {
              // Adjust the double-tap position relative to the current scroll offsets and canvas padding/margin
              final adjustedPosition = Vector2(
                  details.localPosition.dx + horizontalScrollController.offset,
                  details.localPosition.dy + verticalScrollController.offset);

              // Debugging output
              print('--- onDoubleTapDown ---');
              print('Original position: ${details.localPosition}');
              print(
                'Scroll offsets -> Horizontal: ${horizontalScrollController.offset}, Vertical: ${verticalScrollController.offset}',
              );
              print('Adjusted position: $adjustedPosition');

              // Check if the double-tap is on a node
              for (final component in game.children) {
                if (component is SimpleNode &&
                    component.containsPoint(adjustedPosition)) {
                  isDialogVisible = true;

                  chosenProcess = game.processes.firstWhere(
                    (process) => process.id == component.uuid,
                    orElse: () => ProcessData(
                      id: component.uuid,
                      name: "Unknown Process",
                      addOns: [AddOns()],
                    ),
                  );

                  chosenNode = component;
                  break;
                }
              }
            });
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: verticalScrollController,
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  controller: horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                      width: 4000, height: 4000, child: GameWidget(game: game)),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  decoration: newBoxDec(),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        onPressed: () {
                          setState(() {
                            scrollCanvas(-200, 0); // Scroll left
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_upward),
                        onPressed: () {
                          setState(() {
                            scrollCanvas(0, -200); // Scroll up
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () {
                          setState(() {
                            scrollCanvas(0, 200); // Scroll down
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {
                          setState(() {
                            scrollCanvas(200, 0); // Scroll right
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (isDialogVisible)
                Center(
                  child: AlertDialog(
                    title: const Text('Edit Process Data'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: DefaultTabController(
                        length: 2, // Two tabs: Process Data and AddOns
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const TabBar(
                              tabs: [
                                Tab(text: 'Process Data'),
                                Tab(text: 'AddOns'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // Tab 1: Process Data
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Name'),
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
                                              text:
                                                  chosenProcess.processOwner ??
                                                      " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'Estimated Cycle Time'),
                                          onChanged: (value) {
                                            chosenProcess.estCycleTime =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text:
                                                  chosenProcess.estCycleTime ??
                                                      " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'Estimated Cycle Type'),
                                          onChanged: (value) {
                                            chosenProcess.estCycleType =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text:
                                                  chosenProcess.estCycleType ??
                                                      " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Owner Email'),
                                          onChanged: (value) {
                                            chosenProcess.ownerEmail =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: chosenProcess.ownerEmail ??
                                                  " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Owner'),
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
                                              text: chosenProcess.createdBy ??
                                                  " "),
                                        ),
                                        DateTimeField(
                                          initialDate:
                                              chosenProcess.dateCreated ??
                                                  DateTime.now(),
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
                                              text: chosenProcess.changeFrom ??
                                                  " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Process Type'),
                                          onChanged: (value) {
                                            chosenProcess.processType =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: chosenProcess.processType ??
                                                  " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Status'),
                                          onChanged: (value) {
                                            chosenProcess.status =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text:
                                                  chosenProcess.status ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Process Step'),
                                          onChanged: (value) {
                                            chosenProcess.processStep =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: chosenProcess.processStep ??
                                                  " "),
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
                                              text: chosenProcess.usedOnCount
                                                      ?.toString() ??
                                                  "0"),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Revision'),
                                          onChanged: (value) {
                                            chosenProcess.rev =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: chosenProcess.rev ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Version'),
                                          onChanged: (value) {
                                            chosenProcess.ver =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: chosenProcess.ver ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Iteration'),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            chosenProcess.iteration =
                                                num.tryParse(value) ?? 0;
                                          },
                                          controller: TextEditingController(
                                              text: chosenProcess.iteration
                                                      ?.toString() ??
                                                  "0"),
                                        ),
                                        DateTimeField(
                                          initialDate:
                                              chosenProcess.createDate ??
                                                  DateTime.now(),
                                          label: 'Create Date',
                                          onDateSelected: (DateTime value) {
                                            chosenProcess.createDate = value;
                                          },
                                        ),
                                        // Add remaining fields similarly...
                                      ],
                                    ),
                                  ),
                                  // Tab 2: AddOns
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        // AddOn Form Fields
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'AddOn Name'),
                                          onChanged: (value) {
                                            currentAddOn.name =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.name ?? " "),
                                        ),
                                        DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                              labelText: 'SubType'),
                                          value: currentAddOn
                                                      .subType?.isNotEmpty ==
                                                  true
                                              ? currentAddOn.subType
                                              : 'Input',
                                          // Default to 'Input' if null or empty
                                          onChanged: (value) {
                                            setState(() {
                                              currentAddOn.subType = value!;
                                            });
                                          },
                                          items: const [
                                            DropdownMenuItem(
                                                value: 'Input',
                                                child: Text('Input')),
                                            DropdownMenuItem(
                                                value: 'Output',
                                                child: Text('Output')),
                                            DropdownMenuItem(
                                                value: 'Knowledge',
                                                child: Text('Knowledge')),
                                            DropdownMenuItem(
                                                value: 'Business',
                                                child: Text('Business')),
                                            DropdownMenuItem(
                                                value: 'Requirement',
                                                child: Text('Requirement')),
                                            DropdownMenuItem(
                                                value: 'LifeCycle',
                                                child: Text('LifeCycle')),
                                            DropdownMenuItem(
                                                value: 'Condition',
                                                child: Text('Condition')),
                                            DropdownMenuItem(
                                                value: 'Measurement',
                                                child: Text('Measurement')),
                                            DropdownMenuItem(
                                                value: 'Role',
                                                child: Text('Role')),
                                            DropdownMenuItem(
                                                value: 'Equipment',
                                                child: Text('Equipment')),
                                            DropdownMenuItem(
                                                value: 'System',
                                                child: Text('System')),
                                            DropdownMenuItem(
                                                value: 'Tool',
                                                child: Text('Tool')),
                                            DropdownMenuItem(
                                                value: 'Information',
                                                child: Text('Information')),
                                          ],
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Description'),
                                          maxLines: null,
                                          minLines: 4,
                                          onChanged: (value) {
                                            currentAddOn.description =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.description ??
                                                  " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Image'),
                                          onChanged: (value) {
                                            currentAddOn.image =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.image ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Vault'),
                                          onChanged: (value) {
                                            currentAddOn.vault =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.vault ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'URL'),
                                          onChanged: (value) {
                                            currentAddOn.url =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.url ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'URL Label'),
                                          onChanged: (value) {
                                            currentAddOn.urlLabel =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text:
                                                  currentAddOn.urlLabel ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Vault File Name'),
                                          onChanged: (value) {
                                            currentAddOn.vaultFileName =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text:
                                                  currentAddOn.vaultFileName ??
                                                      " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'UDF1'),
                                          onChanged: (value) {
                                            currentAddOn.udf1 =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.udf1 ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'UDF2'),
                                          onChanged: (value) {
                                            currentAddOn.udf2 =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.udf2 ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'UDF3'),
                                          onChanged: (value) {
                                            currentAddOn.udf3 =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.udf3 ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'UDF4'),
                                          onChanged: (value) {
                                            currentAddOn.udf4 =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.udf4 ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'UDF5'),
                                          onChanged: (value) {
                                            currentAddOn.udf5 =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.udf5 ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'UDF6'),
                                          onChanged: (value) {
                                            currentAddOn.udf6 =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.udf6 ?? " "),
                                        ),
                                        SwitchListTile(
                                          title: const Text('UDF7'),
                                          value: currentAddOn.udf7 ?? false,
                                          onChanged: (bool value) {
                                            setState(() {
                                              currentAddOn.udf7 = value;
                                            });
                                          },
                                        ),
                                        SwitchListTile(
                                          title: const Text('UDF8'),
                                          value: currentAddOn.udf8 ?? false,
                                          onChanged: (bool value) {
                                            setState(() {
                                              currentAddOn.udf8 = value;
                                            });
                                          },
                                        ),
                                        DateTimeField(
                                          initialDate: currentAddOn.udf9 ??
                                              DateTime.now(),
                                          label: 'UDF9',
                                          onDateSelected: (DateTime value) {
                                            currentAddOn.udf9 = value;
                                          },
                                        ),
                                        DateTimeField(
                                          initialDate: currentAddOn.udf10 ??
                                              DateTime.now(),
                                          label: 'UDF10',
                                          onDateSelected: (DateTime value) {
                                            currentAddOn.udf10 = value;
                                          },
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Revision'),
                                          onChanged: (value) {
                                            currentAddOn.rev =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.rev ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'Version'),
                                          onChanged: (value) {
                                            currentAddOn.ver =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text: currentAddOn.ver ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'POC Name'),
                                          onChanged: (value) {
                                            currentAddOn.pocName =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text:
                                                  currentAddOn.pocName ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'POC Phone'),
                                          onChanged: (value) {
                                            currentAddOn.pocPhone =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text:
                                                  currentAddOn.pocPhone ?? " "),
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                              labelText: 'POC Email'),
                                          onChanged: (value) {
                                            currentAddOn.pocEmail =
                                                value.isEmpty ? " " : value;
                                          },
                                          controller: TextEditingController(
                                              text:
                                                  currentAddOn.pocEmail ?? " "),
                                        ),

                                        // Grid displaying all AddOns
                                        const SizedBox(height: 16.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  // Save or add the current AddOn to the ProcessData
                                                  if (!chosenProcess.addOns
                                                      .contains(currentAddOn)) {
                                                    chosenProcess.addOns
                                                        .add(currentAddOn);
                                                  }
                                                  // Reset the form for a new entry
                                                  currentAddOn = AddOns();
                                                  if (saveOrAddOn ==
                                                      'Save AddOn') {
                                                    saveOrAddOn = 'Add AddOn';
                                                  }
                                                });
                                                print('634 $saveOrAddOn');
                                              },
                                              child: Text(saveOrAddOn),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  // Check if the current AddOn exists in the list, then remove it
                                                  chosenProcess.addOns
                                                      .remove(currentAddOn);

                                                  // Reset the form after deletion
                                                  currentAddOn = AddOns();
                                                  if (saveOrAddOn ==
                                                      'Save AddOn') {
                                                    saveOrAddOn = 'Add AddOn';
                                                  }
                                                });
                                              },
                                              child:
                                                  const Text('Delete Add On'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16.0),
                                        const Text('AddOns List'),
                                        const SizedBox(height: 8.0),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              chosenProcess.addOns?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            // Sort addOns by subType before building the list
                                            chosenProcess.addOns?.sort((a, b) =>
                                                (a.subType ?? "").compareTo(
                                                    b.subType ?? ""));

                                            final addOn = chosenProcess.addOns![
                                                index]; // Use ! because we're checking for null above
                                            return Card(
                                              child: ListTile(
                                                leading: tooltip(addOn.subType),
                                                title: Text(addOn.name ?? " "),
                                                subtitle: Text(
                                                    addOn.description ?? " "),
                                                trailing: IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    setState(() {
                                                      currentAddOn =
                                                          addOn; // Load the selected AddOn into the form
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
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

  Tooltip tooltip(String? subType) {
    Tooltip returnIcon = const Tooltip(
      message: 'Input',
      child: Icon(
        Icons.input,
        color: kInputIconColor,
      ),
    );

    if (subType == 'Input') {
      returnIcon = const Tooltip(
        message: 'Input',
        child: Icon(
          Icons.input,
          color: kInputIconColor,
        ),
      );
    } else if (subType == 'Output') {
      returnIcon = const Tooltip(
        message: 'Output',
        child: Icon(
          Icons.arrow_forward,
          color: kOutputIconColor,
        ),
      );
    } else if (subType == 'Knowledge') {
      returnIcon = const Tooltip(
        message: 'Knowledge',
        child: Icon(
          Icons.school,
          color: kKnowledgeIconColor,
        ),
      );
    } else if (subType == 'Business') {
      returnIcon = const Tooltip(
        message: 'Business',
        child: Icon(
          Icons.business,
          color: kBusinessIconColor,
        ),
      );
    } else if (subType == 'Requirement') {
      returnIcon = const Tooltip(
        message: 'Requirement',
        child: Icon(
          Icons.assignment,
          color: kRequirementIconColor,
        ),
      );
    } else if (subType == 'LifeCycle') {
      returnIcon = const Tooltip(
        message: 'LifeCycle',
        child: Icon(
          Icons.history,
          color: kLifeCycleIconColor,
        ),
      );
    } else if (subType == 'Condition') {
      returnIcon = const Tooltip(
        message: 'Condition',
        child: Icon(
          Icons.control_point,
          color: kConditionIconColor,
        ),
      );
    } else if (subType == 'Measurement') {
      returnIcon = const Tooltip(
        message: 'Measurement',
        child: Icon(
          Icons.data_usage,
          color: kPrimaryColor,
        ),
      );
    } else if (subType == 'Role') {
      returnIcon = const Tooltip(
        message: 'Role',
        child: Icon(
          Icons.people,
          color: kPerformerIconColor,
        ),
      );
    } else if (subType == 'Equipment') {
      returnIcon = const Tooltip(
        message: 'Equipment',
        child: Icon(
          Icons.precision_manufacturing_outlined,
          color: kEquipmentIconColor,
        ),
      );
    } else if (subType == 'System') {
      returnIcon = Tooltip(
        message: 'System',
        child: Icon(
          Icons.insert_chart,
          color: kSystemIconColor(),
        ),
      );
    } else if (subType == 'Tool') {
      returnIcon = const Tooltip(
        message: 'Tool',
        child: Icon(
          Icons.build,
          color: kToolIconColor,
        ),
      );
    } else if (subType == 'Information') {
      returnIcon = const Tooltip(
        message: 'Information',
        child: Icon(
          Icons.info,
          color: kInformationIconColor,
        ),
      );
    }
    return returnIcon;
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
