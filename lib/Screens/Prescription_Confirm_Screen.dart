import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproject_management_system/Const/InventoryItem.dart';
import 'package:gradproject_management_system/Utils/ColorConverter.dart';
import 'package:gradproject_management_system/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:gradproject_management_system/blocs/orders_bloc/orders_bloc.dart';
import 'package:gradproject_management_system/widgets/Drawer.dart';
import 'package:gradproject_management_system/widgets/backgroundFade.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PrescriptionConfirmScreen extends StatefulWidget {
  // final String? items; // Optional string of items

  const PrescriptionConfirmScreen({super.key});

  @override
  State<PrescriptionConfirmScreen> createState() =>
      _PrescriptionConfirmScreenState();
}

class _PrescriptionConfirmScreenState extends State<PrescriptionConfirmScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? items = ModalRoute.of(context)!.settings.arguments as String?;
    if (items != null && items.trim().isNotEmpty) {
      // Split the string into words (by whitespace)
      List<String> itemWords = items.split(RegExp(r'\s+'));
      bool wantToExit = false;
      for (var word in itemWords) {
        print('Item word: ' + word); // Replace with your logic
        if (wantToExit) {
          break;
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('I Successfully Received Medicine:'),
            content: Text(word + ", The full output was: " + items),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
              TextButton(
                  onPressed: () {
                    wantToExit = true;
                    Navigator.of(context).pop();
                  },
                  child: Text("Exit"))
            ],
          ),
        );
      }
    }
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
              child: myDrawer(selectedIndex: 1),
            ),
            // Body
            BlocConsumer<OrdersBloc, OrdersState>(
              listener: (context, state) {
                print(state.toString());
              },
              builder: (context, state) {
                return Expanded(
                  flex: 5,
                  child: Stack(children: [
                    backgroundFaded(),
                    PrescriptionConfirmScreenBody(context, state)
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

Widget PrescriptionConfirmScreenBody(BuildContext context, OrdersState state) {
  return Placeholder();
}
