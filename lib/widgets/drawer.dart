import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproject_management_system/Utils/ColorConverter.dart';

import '../blocs/status_bloc/status_bloc.dart';

class myDrawer extends StatelessWidget {
  int selectedIndex = 0;
  // 0 -> System Status
  // 1 -> Inventory
  // 2 -> Pending Orders
  // 3 -> New Order

  final TextStyle drawerText = GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      letterSpacing: 1,
      color: Colors.white);
  myDrawer({super.key, required this.selectedIndex});

  final Color drawerColor = hexToColor("2C5F9B");
  final Color menuSelectedColor = hexToColor("1A4E8A");
  final Color menuUnselectedColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hexToColor("2C5F9B"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/logoNew.png"),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 50,
                ),
                headerText(),
                SizedBox(
                  height: 50,
                ),
                statusTile(context),
                inventoryTile(context),
                pendingTile(context),
                prescriptionTile(),
                SizedBox(
                  height: 300,
                ),
                settingsTile(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container settingsTile(BuildContext context) {
    return Container(
      color: selectedIndex == 3 ? menuSelectedColor : menuUnselectedColor,
      child: ListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 30,
              ),
            ),
            Text(
              "Settings",
              style: drawerText,
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/Settings/", (route) => false);
        },
      ),
    );
  }

  Container prescriptionTile() {
    return Container(
      color: selectedIndex == 3 ? menuSelectedColor : menuUnselectedColor,
      child: ListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
            Text(
              "Prescription",
              style: drawerText,
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Container pendingTile(BuildContext context) {
    return Container(
      color: selectedIndex == 2 ? menuSelectedColor : menuUnselectedColor,
      child: ListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.watch_later_sharp,
                color: Colors.white,
                size: 30,
              ),
            ),
            Text(
              "Pending",
              style: drawerText,
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/PendingOrders/", (route) => false);
        },
      ),
    );
  }

  Container inventoryTile(BuildContext context) {
    return Container(
      color: selectedIndex == 1 ? menuSelectedColor : menuUnselectedColor,
      child: ListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.inventory_2_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
            Text(
              "Inventory",
              style: drawerText,
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/Inventory/", (route) => false);
        },
      ),
    );
  }

  Container statusTile(BuildContext context) {
    return Container(
      color: selectedIndex == 0 ? menuSelectedColor : menuUnselectedColor,
      child: ListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.query_stats_sharp,
                color: Colors.white,
                size: 30,
              ),
            ),
            Text(
              "Status",
              style: drawerText,
            ),
          ],
        ),
        onTap: () {
          context.read<StatusBloc>().add(RefreshStatusPageEvent());
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/Status/", (route) => false);
        },
      ),
    );
  }

  Center headerText() {
    return Center(
      child: Text(
        "MY PHARMACY",
        style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            letterSpacing: 5,
            color: Colors.white),
      ),
    );
  }
}
