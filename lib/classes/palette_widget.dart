import 'package:flutter/material.dart';

import 'node_editor_game.dart';

class PaletteWidget extends StatelessWidget {
  final NodeEditorGame game;

  const PaletteWidget({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        final tapPosition = details.localPosition;
        game.palette.handleTap(tapPosition);
      },
      child: CustomPaint(
        size: Size(100, double.infinity),  // Fixed width for the palette
        painter: PalettePainter(game),
      ),
    );
  }
}

class PalettePainter extends CustomPainter {
  final NodeEditorGame game;

  PalettePainter(this.game);

  @override
  void paint(Canvas canvas, Size size) {
    game.palette.render(canvas);  // Only render the palette without grid lines
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
