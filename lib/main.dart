import 'package:flutter/material.dart';
import 'classes/node_editor_app.dart';

String version = '0.5';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      title: 'Process Editor v $version',
      home: NodeEditorApp(),
    );
  }
}

