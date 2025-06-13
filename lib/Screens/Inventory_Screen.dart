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

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

final List<inventoryItem> _filteredInventoryList = [];

class _InventoryScreenState extends State<InventoryScreen> {
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
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            // Drawer
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 270),
              child: myDrawer(selectedIndex: 1),
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
                    InventoryScreenBody(context, state)
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

Widget InventoryScreenBody(BuildContext context, InventoryState state) {
  return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "INVENTORY",
            style: GoogleFonts.montserrat(
              fontSize: 72,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 10,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SearchBar(
                      leading: Icon(
                        Icons.search,
                        size: 30,
                        color: hexToColor("5A8CDA"),
                      ),
                      hintText: "Search Medication..",
                      onChanged: (value) {
                        print(value);
                        context.read<InventoryBloc>().add(InventorySearchEvent(
                              searchTerm: value,
                            ));
                      },
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          //! ITEMS
          BlocConsumer<InventoryBloc, InventoryState>(
            listener: (context, state) {
              if (state is InventorySearched) {
                _updateFilteredInventoryList(
                    state.searchTerm, state.inventoryItems);
              }
            },
            buildWhen: (previous, current) {
              return current is InventorySearched;
            },
            builder: (context, state) {
              print("Building Inventory List");
              return Expanded(
                child: ListView.builder(
                  itemCount: _filteredInventoryList.length,
                  itemBuilder: (context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: inventoryItemWidget(
                          item: _filteredInventoryList[index]),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ));
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
      padding: const EdgeInsets.only(
        right: 40.0,
      ),
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
                            fontSize: 32,
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
                            fontSize: 24,
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
                    //! PRICE
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              "Price",
                              style: GoogleFonts.openSans(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: hexToColor("212529"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 16),
                            child: Text(
                              "${item.medication.price.toString()}EGP",
                              style: GoogleFonts.openSans(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

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
                                fontSize: 30,
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
                    //! SHELF NO
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              "Shelf No.",
                              style: GoogleFonts.openSans(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: hexToColor("212529"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 16),
                            child: Text(
                              "${item.shelfNo.toString()}",
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
            // Icon button for actions (always at the end)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: hexToColor("212529"), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_horiz, color: hexToColor("212529")),
                  onSelected: (String value) {
                    if (value == 'update') {
                      // Show modal bottom sheet for update
                      updateItemMenu(context);
                    } else if (value == 'delete') {
                      // TODO: Implement delete logic, e.g. dispatch event
                      // context.read<InventoryBloc>().add(DeleteInventoryItemEvent(item));
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'update',
                      child: Text('Update'),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> updateItemMenu(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final quantityController =
            TextEditingController(text: item.quantity.toString());
        final shelfNoController =
            TextEditingController(text: item.shelfNo.toString());
        final priceController =
            TextEditingController(text: item.medication.price.toString());
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Update Item',
                  style: GoogleFonts.openSans(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              Text('Price', style: GoogleFonts.openSans(fontSize: 18)),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter price',
                ),
              ),
              SizedBox(height: 16),
              Text('Quantity', style: GoogleFonts.openSans(fontSize: 18)),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter quantity',
                ),
              ),
              SizedBox(height: 16),
              Text('Shelf No.', style: GoogleFonts.openSans(fontSize: 18)),
              TextField(
                controller: shelfNoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter shelf number',
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement update logic (e.g., dispatch event)
                      try {
                        final newPrice = int.parse(priceController.text);
                        final newShelfNo = int.parse(shelfNoController.text);
                        final newQuantity = int.parse(quantityController.text);

                        final newItem = item.copyWith(
                          medication: item.medication.copyWith(
                            price: newPrice,
                          ),
                          shelfNo: newShelfNo,
                          quantity: newQuantity,
                        );
                        context.read<InventoryBloc>().add(
                              UpdateSingleInventoryItemEvent(
                                  updatedItem: newItem),
                            );
                        // Update the item in the inventory
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Invalid input. Please check your values.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hexToColor("2C5F9B"),
                    ),
                  ),
                  SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

void _updateFilteredInventoryList(
    String searchText, List<inventoryItem> inventoryList) {
  _filteredInventoryList.clear();
  if (searchText.isEmpty) {
    _filteredInventoryList.addAll(inventoryList);
  } else {
    for (var item in inventoryList) {
      if (item.medication.name
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          item.medication.active_ingredient
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          item.medication.description
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
        _filteredInventoryList.add(item);
      }
    }
  }
}
