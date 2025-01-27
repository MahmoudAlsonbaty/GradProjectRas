import 'package:flutter/material.dart';
import 'package:gradproject_management_system/widgets/drawer.dart';

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
      backgroundColor: Color.fromRGBO(165, 212, 227, 1),
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            // Drawer
            Flexible(
              flex: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 270), // Logo Max Width
                child: myDrawer(
                  selectedIndex: 0,
                ),
              ),
            ),
            // Body
            Expanded(
              flex: 5,
              child: statusScreenBody(),
            ),
          ],
        );
      }),
    );
  }
}

Widget statusScreenBody() {
  return Column(
    children: [
      Text("Status Screen Body"),
    ],
  );
}
