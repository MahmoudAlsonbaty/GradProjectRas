import 'package:flutter/material.dart';

class myDrawer extends StatelessWidget {
  int selectedIndex = 0;
  // 0 -> System Status
  // 1 -> Inventory
  // 2 -> Pending Orders
  // 3 -> New Order

  myDrawer({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(42, 58, 62, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/logo.png"),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  color: selectedIndex == 0
                      ? Color.fromRGBO(165, 212, 227, 1)
                      : Color.fromRGBO(217, 236, 242, 1),
                  child: ListTile(
                    title: Center(child: Text("System Status")),
                    onTap: () {},
                  ),
                ),
                Container(
                  color: selectedIndex == 1
                      ? Color.fromRGBO(165, 212, 227, 1)
                      : Color.fromRGBO(217, 236, 242, 1),
                  child: ListTile(
                    title: Center(child: Text("Inventory")),
                    onTap: () {},
                  ),
                ),
                Container(
                  color: selectedIndex == 2
                      ? Color.fromRGBO(165, 212, 227, 1)
                      : Color.fromRGBO(217, 236, 242, 1),
                  child: ListTile(
                    title: Center(child: Text("Pending Orders")),
                    onTap: () {},
                  ),
                ),
                Container(
                  color: selectedIndex == 3
                      ? Color.fromRGBO(165, 212, 227, 1)
                      : Color.fromRGBO(217, 236, 242, 1),
                  child: ListTile(
                    title: Center(child: Text("New Order")),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
