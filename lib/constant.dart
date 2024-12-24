import 'package:flutter/material.dart';

final kSelectedColor = Colors.blue;
final kColorsWithoutselectedColor = Colors.primaries.toList()
  ..remove(Colors.blue)
  ..remove(Colors.lightBlue)
  ..remove(Colors.cyan);
