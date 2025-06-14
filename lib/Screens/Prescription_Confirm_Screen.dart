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
  // List to hold selected medications
  final List<inventoryItem> selectedMedications = [];
  final ValueNotifier<String> searchTerm = ValueNotifier("");
  final ValueNotifier<List<inventoryItem>> searchResults = ValueNotifier([]);

  void addMedication(inventoryItem item) {
    if (!selectedMedications
        .any((i) => i.medication.name == item.medication.name)) {
      setState(() {
        selectedMedications.add(item.copyWith(
          quantity: 1, // Ensure quantity is at least 1
        ));
      });
    }
  }

  void clearSelection() {
    setState(() {
      selectedMedications.clear();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? items = ModalRoute.of(context)!.settings.arguments as String?;
    if (items != null && items.trim().isNotEmpty) {
      // Split the string into words (by whitespace)
      List<String> itemWords = items.split(RegExp(r'\\s+'));
      final inventoryState = BlocProvider.of<InventoryBloc>(context).state;
      if (inventoryState is InventoryLoaded) {
        for (var name in itemWords) {
          final matches = inventoryState.inventoryItems.where(
            (item) => item.medication.name.toLowerCase() == name.toLowerCase(),
          );
          if (matches.isNotEmpty) {
            final match = matches.first;
            if (!selectedMedications
                .any((i) => i.medication.name == match.medication.name)) {
              setState(() {
                selectedMedications.add(match);
              });
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Removed BlocProvider<OrdersBloc> wrapper to use the global OrdersBloc
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Drawer
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 270),
                child: myDrawer(selectedIndex: 3),
              ),
              // Body
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    backgroundFaded(),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 80.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "NEW PRESCRIPTION",
                            style: GoogleFonts.montserrat(
                              fontSize: 72,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 10,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: ValueListenableBuilder<String>(
                                    valueListenable: searchTerm,
                                    builder: (context, value, _) => Column(
                                      children: [
                                        SearchBar(
                                          leading: Icon(
                                            Icons.search,
                                            size: 30,
                                            color: hexToColor("5A8CDA"),
                                          ),
                                          hintText:
                                              "Search by medicine name...",
                                          onChanged: (val) {
                                            searchTerm.value = val;
                                            if (val.isNotEmpty) {
                                              final inventoryBloc = BlocProvider
                                                  .of<InventoryBloc>(context);
                                              final inventoryState =
                                                  inventoryBloc.state;
                                              if (inventoryState
                                                  is InventoryLoaded) {
                                                searchResults.value =
                                                    inventoryState
                                                        .inventoryItems
                                                        .where((item) => item
                                                            .medication.name
                                                            .toLowerCase()
                                                            .contains(val
                                                                .toLowerCase()))
                                                        .toList();
                                              }
                                            } else {
                                              searchResults.value = [];
                                            }
                                          },
                                          shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        ValueListenableBuilder<
                                            List<inventoryItem>>(
                                          valueListenable: searchResults,
                                          builder: (context, results, _) {
                                            if (searchTerm.value.isEmpty ||
                                                results.isEmpty) {
                                              return SizedBox.shrink();
                                            }
                                            return Container(
                                              margin: EdgeInsets.only(top: 8),
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 8,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              constraints: BoxConstraints(
                                                  maxHeight: 250),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: results.length,
                                                itemBuilder: (context, idx) {
                                                  final item = results[idx];
                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          "assets/medication.jpg"),
                                                    ),
                                                    title: Text(
                                                        item.medication.name,
                                                        style: GoogleFonts
                                                            .openSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    subtitle: Text(item
                                                        .medication
                                                        .active_ingredient),
                                                    trailing: Text("Qty: " +
                                                        item.quantity
                                                            .toString()),
                                                    onTap: () {
                                                      addMedication(item);
                                                      searchTerm.value = "";
                                                      searchResults.value = [];
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Show selected medications
                          if (selectedMedications.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selected Medications:",
                                  style: GoogleFonts.openSans(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ...selectedMedications.map((item) => Card(
                                      color: Colors.white,
                                      child: ListTile(
                                        title: Text(item.medication.name),
                                        subtitle: Text(
                                            item.medication.active_ingredient),
                                        trailing: Text("Qty: ${item.quantity}"),
                                        leading: IconButton(
                                          icon: Icon(Icons.remove_circle,
                                              color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              selectedMedications.remove(item);
                                            });
                                          },
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          Spacer(),
                          // Confirm and Cancel buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  clearSelection();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text("Cancel",
                                    style: TextStyle(fontSize: 20)),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: selectedMedications.isEmpty
                                    ? null
                                    : () {
                                        final newOrder = Order(
                                          orderId: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          items: List<inventoryItem>.from(
                                              selectedMedications),
                                        );
                                        context.read<OrdersBloc>().add(
                                            AddOrderEvent(newOrder: newOrder));
                                        clearSelection();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('Order confirmed!')),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text("Confirm",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
