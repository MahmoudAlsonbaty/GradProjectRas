import 'package:dart_periphery/dart_periphery.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradproject_management_system/Const/InventoryItem.dart';
import 'package:gradproject_management_system/Utils/ColorConverter.dart';
import 'package:gradproject_management_system/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:gradproject_management_system/blocs/orders_bloc/orders_bloc.dart';
import 'package:gradproject_management_system/blocs/serial_bloc/serial_bloc.dart';
import 'package:gradproject_management_system/widgets/Drawer.dart';
import 'package:gradproject_management_system/widgets/backgroundFade.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({super.key});

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  int? selectedOrderIndex;

  @override
  void initState() {
    super.initState();
    // Dispatch FetchInventoryFromCloudEvent when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryBloc>().add(FetchInventoryFromCloudEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {
          // TODO: Add any side effects here if needed
          if (state is OrdersLoaded) {
            print("Pending Orders Loaded: ${state.pendingOrders.length}");
            // If the selected order was deleted, clear selection
            if (selectedOrderIndex != null &&
                selectedOrderIndex! >= state.pendingOrders.length) {
              setState(() {
                selectedOrderIndex = null;
              });
            }
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  // Drawer
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 270),
                    child: myDrawer(selectedIndex: 2),
                  ),
                  // Drawer
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Menu(
                      state: state,
                      selectedIndex: selectedOrderIndex,
                      onOrderTap: (idx) {
                        setState(() {
                          selectedOrderIndex = idx;
                        });
                      },
                    ),
                  ),
                  // Body
                  Expanded(
                    flex: 5,
                    child: Stack(
                      children: [
                        backgroundFaded(),
                        PendingOrdersScreenBody(
                            context, state, selectedOrderIndex),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

Widget PendingOrdersScreenBody(
    BuildContext context, OrdersState state, int? selectedOrderIndex) {
  if (state is OrdersLoaded &&
      selectedOrderIndex != null &&
      selectedOrderIndex >= 0 &&
      selectedOrderIndex < state.pendingOrders.length) {
    final order = state.pendingOrders[selectedOrderIndex];
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: order.items.length,
            itemBuilder: (context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: inventoryItemWidget(item: order.items[index]),
              );
            },
          ),
        ),
        // Add the dark transparent container with centered text above the buttons
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
          ),
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 16),
          child: Text(
            'TOTAL PRICE: ${order.items.fold(0, (sum, item) => sum + (item.medication.price * item.quantity)).toStringAsFixed(2)} EGP',
            style: GoogleFonts.montserrat(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Delete logic: remove order from pending orders
                  context
                      .read<OrdersBloc>()
                      .add(DeleteOrderEvent(index: selectedOrderIndex));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order deleted!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Delete',
                  style:
                      GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
                ),
              ),
              // Spacer to push Confirm button to the right
              ElevatedButton(
                onPressed: () {
                  SendOrderToRobot(state, context, selectedOrderIndex);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Confirm',
                  style:
                      GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  return Center(
    child: Text(
      'Select an order to view details.',
      style: GoogleFonts.montserrat(fontSize: 24, color: Colors.white),
    ),
  );
}

class Menu extends StatelessWidget {
  final OrdersState? state;
  final int? selectedIndex;
  final void Function(int)? onOrderTap;
  Menu({super.key, this.state, this.selectedIndex, this.onOrderTap});

  final TextStyle drawerText = GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      letterSpacing: 1,
      color: Colors.white);

  final Color drawerColor = hexToColor("2C5F9B");
  final Color menuSelectedColor = hexToColor("1A4E8A");
  final Color menuUnselectedColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    List<Widget> orderWidgets = [];
    if (state is OrdersLoaded) {
      final orders = (state as OrdersLoaded).pendingOrders;
      if (orders.isEmpty) {
        orderWidgets.add(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "No pending orders.",
              style: drawerText,
            ),
          ),
        );
      } else {
        for (int i = 0; i < orders.length; i++) {
          final order = orders[i];
          orderWidgets.add(GestureDetector(
            onTap: () => onOrderTap?.call(i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selectedIndex == i ? Colors.blue[700] : Colors.blue,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selectedIndex == i ? Colors.white : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order ID: ${order.orderId}",
                    style: drawerText.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    order.orderFrom,
                    style: drawerText.copyWith(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ));
        }
      }
    } else {
      orderWidgets.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Loading orders...",
            style: drawerText,
          ),
        ),
      );
    }

    return Container(
      color: hexToColor("2C5F9B"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          headerText(),
          SizedBox(height: 30),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: orderWidgets,
            ),
          ),
        ],
      ),
    );
  }
}

Center headerText() {
  return Center(
    child: Text(
      "ORDERS",
      style: GoogleFonts.montserrat(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: 5,
          color: Colors.white),
    ),
  );
}

class inventoryItemWidget extends StatelessWidget {
  final inventoryItem item;
  const inventoryItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: hexToColor("2C5F9B"),
          borderRadius: BorderRadius.circular(25),
        ),
        height: 145,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  //! IMAGE
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 130, // 150 - 10 - 10 Padding
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: Image.asset("assets/medication.jpg").image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  //! MEDICATION NAME
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${item.medication.name} (${item.medication.strength})",
                          style: GoogleFonts.openSans(
                            fontSize: 32, // smaller
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "${item.medication.active_ingredient}\n${item.medication.description}",
                          style: GoogleFonts.openSans(
                            fontSize: 24, // smaller
                            color: hexToColor("212529"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //! Divider

            VerticalDivider(
              color: Colors.grey,
              thickness: 2,
              // width: 20,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    //! QUANTITY

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              "Quantity",
                              style: GoogleFonts.openSans(
                                fontSize: 20, // smaller
                                fontWeight: FontWeight.w700,
                                color: hexToColor("212529"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 16),
                            child: Text(
                              "${item.quantity}",
                              style: GoogleFonts.openSans(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

void SendOrderToRobot(
    OrdersLoaded state, BuildContext context, int selectedOrderIndex) {
  // Build order string in format GRABSSxQQ,SSxQQ
  final orderObj = state.pendingOrders[selectedOrderIndex];
  String order = orderObj.items.map((item) {
    String shelf = item.shelfNo.toString().padLeft(2, '0');
    String qty = '01';
    return '$shelf' 'x' '$qty';
  }).join(',');
  // You can now use the 'order' string for serial communication
  order = "GRAB" + order;
  print(order);
  // Send the order string via serial
  context.read<SerialBloc>().add(SendSerialMessage(order));
  context.read<OrdersBloc>().add(DeleteOrderEvent(index: selectedOrderIndex));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Order confirmed!')),
  );
}
