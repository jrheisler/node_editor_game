import 'package:flutter/material.dart';

import '../models/process_model.dart';

class EditProcessDialog extends StatefulWidget {
  final ProcessData processData;
  final Function(ProcessData) onSave;
  final Function onDeleteNode;
  final Function onDeleteArrows;

  const EditProcessDialog({
    Key? key,
    required this.processData,
    required this.onSave,
    required this.onDeleteNode,
    required this.onDeleteArrows,
  }) : super(key: key);

  @override
  _EditProcessDialogState createState() => _EditProcessDialogState();
}

class _EditProcessDialogState extends State<EditProcessDialog> {
  late TextEditingController nameController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.processData.name);
    descController = TextEditingController(text: widget.processData.desc);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Node'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Name'),
            controller: nameController,
            onChanged: (value) {
              setState(() {
                widget.processData.name = value;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Description'),
            controller: descController,
            onChanged: (value) {
              setState(() {
                widget.processData.desc = value;
              });
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onDeleteNode();
            Navigator.of(context).pop();
          },
          child: const Text('Delete Node'),
        ),
        TextButton(
          onPressed: () {
            widget.onDeleteArrows();
            Navigator.of(context).pop();
          },
          child: const Text('Delete Attached Arrows'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave(widget.processData);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
