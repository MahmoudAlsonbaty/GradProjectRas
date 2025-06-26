import 'dart:developer' as developer;
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproject_management_system/Const/InventoryItem.dart';
import 'package:gradproject_management_system/Utils/ColorConverter.dart';
import 'package:gradproject_management_system/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:gradproject_management_system/widgets/Drawer.dart';
import 'package:gradproject_management_system/widgets/backgroundFade.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key}); // Modify the constructor

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

final List<inventoryItem> _filteredInventoryList = [];

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            // Drawer
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 270),
              child: myDrawer(selectedIndex: 3),
            ),
            // Body
            BlocConsumer<InventoryBloc, InventoryState>(
              listener: (context, state) {
                print(state.toString());
                if (state is InventoryLoaded) {
                  _filteredInventoryList.clear();
                  _filteredInventoryList.addAll(state.inventoryItems);
                }
              },
              buildWhen: (previous, current) {
                // Only rebuild if the state is InventoryLoaded
                return current is InventoryLoaded;
              },
              builder: (context, state) {
                return Expanded(
                  flex: 5,
                  child: Stack(children: [
                    backgroundFaded(),
                    PrescriptionScreenBody(
                      context,
                      state,
                    )
                  ]),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}

Widget PrescriptionScreenBody(BuildContext context, InventoryState state) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NEW PRESCRIPTION',
              style: GoogleFonts.montserrat(
                fontSize: 72,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 10,
              ),
            ),
          ],
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Manual Entry Button
              GestureDetector(
                onTap: () async {
                  print('Scan Prescription button tapped');
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    "/PrescriptionConfirm/",
                    (route) => false,
                  );
                },
                child: Container(
                  height: 400,
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0056A3),
                        Color(0xFF00396D),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 2),
                      left: BorderSide(color: Colors.white, width: 2),
                      right: BorderSide.none,
                      bottom: BorderSide.none,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.keyboard, color: Colors.white, size: 60),
                      SizedBox(height: 24),
                      Text(
                        'MANUAL ENTRY',
                        style: GoogleFonts.openSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Vertical Divider
              Container(
                width: 2,
                height: 180,
                color: Colors.white.withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: 16),
              ),
              // Scan Prescription Button
              GestureDetector(
                onTap: () async {
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //   "/PrescriptionConfirm/",
                  //   (route) => false,
                  //   arguments: """DEBUG: Picamera2 object created.
                  //      Milga""",
                  // );
                  print('Scan Prescription button tapped');
                  final result = await Process.run('python3',
                      ['/home/pharma/Desktop/prescriptionScanScript.py']);
                  String output = result.stdout.toString().trim();
                  developer.log('Output Recieved from Script: $output',
                      name: 'Prescription Script');
                  if (output.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Scan failed'),
                        content: Text("Scan Failed, please try again."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      "/PrescriptionConfirm/",
                      (route) => false,
                      arguments: output,
                    );
                  }
                },
                child: Container(
                  height: 400,
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0056A3),
                        Color(0xFF00396D),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border(
                      top: BorderSide.none,
                      left: BorderSide.none,
                      right: BorderSide(color: Colors.white, width: 2),
                      bottom: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.view_in_ar, // Icon for scan prescription
                          color: Colors.white,
                          size: 60),
                      SizedBox(height: 24),
                      Text(
                        'SCAN PRESCRIPTION',
                        style: GoogleFonts.openSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
