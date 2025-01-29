import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/status_bloc/status_bloc.dart';

class myDrawer extends StatelessWidget {
  int selectedIndex = 0;
  // 0 -> System Status
  // 1 -> Inventory
  // 2 -> Pending Orders
  // 3 -> New Order

  final TextStyle drawerText =
      GoogleFonts.roboto(fontSize: 19, fontWeight: FontWeight.bold);
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
                    title: Center(
                        child: Text(
                      "System Status",
                      style: drawerText,
                    )),
                    onTap: () {
                      context.read<StatusBloc>().add(RefreshStatusPageEvent());
                    },
                  ),
                ),
                Container(
                  color: selectedIndex == 1
                      ? Color.fromRGBO(165, 212, 227, 1)
                      : Color.fromRGBO(217, 236, 242, 1),
                  child: ListTile(
                    title: Center(
                        child: Text(
                      "Inventory",
                      style: drawerText,
                    )),
                    onTap: () {},
                  ),
                ),
                Container(
                  color: selectedIndex == 2
                      ? Color.fromRGBO(165, 212, 227, 1)
                      : Color.fromRGBO(217, 236, 242, 1),
                  child: ListTile(
                    title: Center(
                        child: Text(
                      "Pending Orders",
                      style: drawerText,
                    )),
                    onTap: () {},
                  ),
                ),
                Container(
                  color: selectedIndex == 3
                      ? Color.fromRGBO(165, 212, 227, 1)
                      : Color.fromRGBO(217, 236, 242, 1),
                  child: ListTile(
                    title: Center(
                        child: Text(
                      "New Order",
                      style: drawerText,
                    )),
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
