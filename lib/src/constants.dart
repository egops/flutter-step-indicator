import 'package:flutter/material.dart';

const double kIconSize = 16;
const double kDefaultSize = 20;
const double kDefaultThickness = 2;
const double kDefaultLineHeight = 2.5;
const IconData kCompletedIcon = Icons.check_outlined;
const Color kActiveColor = Color.fromRGBO(48, 71, 104, 1);
const Color kInActiveColor = const Color(0xffc4c4c4);
const Color kCompleteColor = Colors.green;
const Color kInActiveNodeColor = Colors.transparent;
const Color kActiveLineColor = kActiveColor;
const Color kInActiveLineColor = kInActiveColor;
const Color kIconColor = Colors.white;
typedef Future<bool> Complete();
