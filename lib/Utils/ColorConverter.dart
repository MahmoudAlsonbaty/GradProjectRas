import 'package:flutter/material.dart';

Color hexToColor(String hexCode) {
  final hex = hexCode.replaceAll('#', '');
  return Color(int.parse('FF$hex', radix: 16));
}
