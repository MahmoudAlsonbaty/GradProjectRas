import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradproject_management_system/Screens/Inventory_Screen.dart';
import 'package:gradproject_management_system/Screens/Pending_Orders_Screen.dart';
import 'package:gradproject_management_system/Screens/Status_Screen.dart';
import 'package:gradproject_management_system/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:gradproject_management_system/blocs/orders_bloc/orders_bloc.dart';
import 'package:gradproject_management_system/blocs/serial_bloc/serial_bloc.dart';
import 'package:gradproject_management_system/blocs/status_bloc/status_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  runApp(const ManagementApp());
}

//! WE HAVE 9*3 SHELVES

class ManagementApp extends StatelessWidget {
  const ManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SerialBloc>(
          create: (BuildContext context) => SerialBloc(),
        ),
        BlocProvider<InventoryBloc>(
          create: (BuildContext context) => InventoryBloc(),
        ),
        BlocProvider<OrdersBloc>(
          create: (BuildContext context) => OrdersBloc(),
        ),
        BlocProvider<StatusBloc>(
          create: (BuildContext context) =>
              StatusBloc()..add(RefreshStatusPageEvent()),
        ),
      ],
      child: GlobalLoaderOverlay(
        child: MaterialApp(
          title: 'Management System',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          ),
          home: const StatusScreen(),
          routes: {
            "/Status/": (context) {
              return const StatusScreen();
            },
            "/Inventory/": (context) {
              return const InventoryScreen();
            },
            "/PendingOrders/": (context) {
              return const PendingOrdersScreen();
            },
          },
        ),
      ),
    );
  }
}
