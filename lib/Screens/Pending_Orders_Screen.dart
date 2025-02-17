import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproject_management_system/Const/order.dart';
import 'package:gradproject_management_system/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:gradproject_management_system/blocs/orders_bloc/orders_bloc.dart';
import 'package:gradproject_management_system/blocs/status_bloc/status_bloc.dart';
import 'package:gradproject_management_system/widgets/Drawer.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({super.key});

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
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
                  selectedIndex: 2,
                ),
              ),
            ),
            // Body
            BlocConsumer<OrdersBloc, OrdersState>(
              listener: (context, state) {
                print(state.toString());
              },
              builder: (context, state) {
                return Expanded(
                  flex: 5,
                  child:
                      pendingOrdersScreenBody(context, state as OrdersUpdated),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}

Widget pendingOrdersScreenBody(BuildContext context, OrdersUpdated state) {
  return Padding(
    padding: const EdgeInsets.all(32.0),
    child: ListView.builder(
      itemCount: state.pendingOrders.length,
      itemBuilder: (context, index) =>
          pendingOrderWidget(context, index, state.pendingOrders[index]),
    ),
  );
}

Widget pendingOrderWidget(BuildContext context, index, ORDER order) {
  return Container(
    decoration: BoxDecoration(
        color: Color.fromRGBO(217, 236, 242, 1),
        border: Border.all(color: Colors.white.withAlpha(35), width: 2.5),
        borderRadius: const BorderRadius.all(Radius.circular(25))),
    child: Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 8, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //! MEDICINE ICON
          Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(1, 127, 162, 1),
                border:
                    Border.all(color: Colors.white.withAlpha(35), width: 2.5),
                borderRadius: const BorderRadius.all(Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.medication_sharp,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          //! ORDER NO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order No. \n       ${index + 1}",
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          SizedBox(
            width: 60,
          ),
          //! ITEMS
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Items:",
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              ...order.requestsList
                  .map((REQUEST req) => Row(
                        children: [
                          Text("Medicine : ",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          Text("${req.medicineName}",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(", Quantity : ",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          Text("${req.orderQuantity}",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(", Shelf No.",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          Text("${req.shelfNo}",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ))
                  .toList()
            ],
          ),
          SizedBox(
            width: 60,
          ),
          Spacer(),
          IconButton(
              onPressed: () {
                //! Delete Order
                context.read<OrdersBloc>().add(DeleteOrderEvent(number: index));
              },
              icon: Icon(
                Icons.delete_forever,
                size: 60,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () async {
                // TODO : Send the order to the AVR
                context.loaderOverlay.show(
                  widgetBuilder: (progress) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.green, size: 150),
                    );
                  },
                );
                await Future.delayed(Duration(seconds: 3));
                context.loaderOverlay.hide();
              },
              icon: Icon(
                Icons.check_box,
                size: 60,
                color: Colors.green,
              )),
        ],
      ),
    ),
  );
}
