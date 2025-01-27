import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class myDrawer extends StatelessWidget {
  const myDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(0, 0, 255, 255),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Image.asset("assets/logo.png"),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
