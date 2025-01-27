import 'package:flutter/material.dart';

class myDrawer extends StatelessWidget {
  const myDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset("assets/logo.png"),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: Text("Dashboard"),
                onTap: () {},
              ),
            ],
          ),
        )
      ],
    );
  }
}
