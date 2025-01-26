import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradproject_management_system/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:gradproject_management_system/blocs/orders_bloc/orders_bloc.dart';
import 'package:gradproject_management_system/blocs/serial_bloc/serial_bloc.dart';

void main() {
  runApp(const ManagementApp());
}

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
      ],
      child: MaterialApp(
        title: 'Management System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomePage(title: 'Management System Home Page'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
