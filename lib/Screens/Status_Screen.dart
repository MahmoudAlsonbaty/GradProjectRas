import 'package:flutter/material.dart';
import 'package:gradproject_management_system/Screens/drawer.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, required this.title});
  final String title;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Row(
          children: [
            // Drawer
            myDrawer()
          ],
        ));
  }
}
