import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradproject_management_system/Screens/Inventory_Screen.dart';
import 'package:gradproject_management_system/Screens/Pending_Orders_Screen.dart';
import 'package:gradproject_management_system/Screens/Prescription_Confirm_Screen.dart';
import 'package:gradproject_management_system/Screens/Prescription_Screen.dart';
import 'package:gradproject_management_system/Screens/Status_Screen.dart';
import 'package:gradproject_management_system/Screens/Settings_Screen.dart';
import 'package:gradproject_management_system/blocs/interaction_bloc/interaction_bloc.dart';
import 'package:gradproject_management_system/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:gradproject_management_system/blocs/orders_bloc/orders_bloc.dart';
import 'package:gradproject_management_system/blocs/serial_bloc/serial_bloc.dart';
import 'package:gradproject_management_system/blocs/status_bloc/status_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://loalgmwcpxyuoirradnd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxvYWxnbXdjcHh5dW9pcnJhZG5kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3NTc0NzIsImV4cCI6MjA2MjMzMzQ3Mn0.U5_yIuOrKUViqvUA7AD4Yur7zUNgBVAt28IRwilaOkg',
  );
  runApp(const ManagementApp());
}

//! WE HAVE 8*3 SHELVES

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
        BlocProvider<InteractionBloc>(
          create: (BuildContext context) =>
              InteractionBloc()..add(FetchInteractionList()),
          lazy: false,
        ),
      ],
      child: GlobalLoaderOverlay(
        child: MaterialApp(
          title: 'Management System',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          ),
          // home: const StatusScreen(),
          home: const InventoryScreen(),
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
            "/Settings/": (context) {
              return const SettingsScreen();
            },
            "/NewPrescription/": (context) {
              return const PrescriptionScreen();
            },
            "/PrescriptionConfirm/": (context) {
              return const PrescriptionConfirmScreen();
            },
          },
        ),
      ),
    );
  }
}
