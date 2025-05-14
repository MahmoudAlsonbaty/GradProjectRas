import 'package:flutter/material.dart';
import 'package:gradproject_management_system/Utils/ColorConverter.dart';

Widget backgroundFaded() {
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/backgroundWallpaper.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [hexToColor("6DA0EF"), hexToColor("6DA0EF").withAlpha(100)],
            stops: [0.1, 0.74],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    ],
  );
}
