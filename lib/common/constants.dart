import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<Color> kAvailableColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.black,
  Colors.white,
  Colors.blueGrey,
];

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 12, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 12, kToday.day);

const kTabletBreakpoint = 660.0;
const kDesktopBreakpoint = 1400.0;
const kSideMenuWidth = 200.0;

//const kPrimaryColor = Colors.teal;
const kPrimaryColor = Colors.deepPurple;

Color kPrimaryVariantColor = getPrimaryVariant();

getPrimaryVariant() {
//const kPrimaryVariantColor = Colors.tealAccent;
  return Colors.deepPurpleAccent;
}




Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

const kSerialsColor = Colors.cyanAccent;
const kVaultColor = Colors.indigo;
const kVersionColor = Colors.deepPurple;
const kEditIconColor = Colors.green;

const kRequirementIconColor = Colors.redAccent;
const kLifeCycleIconColor = Colors.blueGrey;
const kKnowledgeIconColor = Colors.lightBlueAccent;
const kEquipmentIconColor = Colors.brown;
const kInformationIconColor = Colors.deepOrange;
const kToolIconColor = Colors.amber;
const kOutputIconColor = Colors.green;
const kConditionIconColor = Colors.red;
const kInputIconColor = Colors.lime;
const kUdfColor = Colors.brown;
const kSearchIntoColor = Colors.purple;
const kBusinessIconColor = Colors.blue;
const kPerformerIconColor = Colors.deepOrangeAccent;
const kMaterialIconColor = Colors.deepPurple;

const kUsedOnIconColor = Colors.red;
const kShadowColor = Colors.yellow;
const kDialogBright = Colors.yellow;
const kDividerColor = Colors.black;
const kBuildColor = Colors.blue;
const kReportColor = Colors.lightBlueAccent;
const kIdentifierColor = Colors.blueGrey;
Color? kSystemIconColor() {
  return Colors.brown[800];
}
Color kColorDarkToLight() {
  return Colors.black;
}

BoxDecoration newBoxDec({
  Color? boxColor,
  Color? shadowColor,
  Color? borderColor,
}) {
  if (borderColor == null) borderColor = kPrimaryColor;
  if (shadowColor == null) shadowColor = kColorDarkToLight();
  if (boxColor == null) boxColor = kColorDarkToLight();
  return BoxDecoration(
    borderRadius: BorderRadius.circular(5.0),
    color: boxColor,
    border: Border(
      top: BorderSide(color: borderColor, width: 1.0),
      left: BorderSide(color: borderColor, width: 1.0),
      bottom: BorderSide(color: borderColor, width: 1.0),
      right: BorderSide(color: borderColor, width: 1.0),
    ),
    //borderRadius: BorderRadius.circular(20.0),
    boxShadow: [
      BoxShadow(
        color: shadowColor,
        offset: const Offset(0, 2),
        blurRadius: 2.0,
      ),
    ],
  );
}