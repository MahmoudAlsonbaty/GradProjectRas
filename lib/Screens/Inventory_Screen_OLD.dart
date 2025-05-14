// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gradproject_management_system/blocs/inventory_bloc/inventory_bloc.dart';
// import 'package:gradproject_management_system/widgets/Drawer.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// class InventoryScreen extends StatefulWidget {
//   const InventoryScreen({super.key});

//   @override
//   State<InventoryScreen> createState() => _InventoryScreenState();
// }

// class _InventoryScreenState extends State<InventoryScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(165, 212, 227, 1),
//       body: LayoutBuilder(builder: (context, constraints) {
//         return Row(
//           children: [
//             // Drawer
//             Flexible(
//               flex: 1,
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(maxWidth: 270), // Logo Max Width
//                 child: myDrawer(
//                   selectedIndex: 1,
//                 ),
//               ),
//             ),
//             // Body
//             BlocConsumer<InventoryBloc, InventoryState>(
//               listener: (context, state) {
//                 print(state.toString());
//               },
//               builder: (context, state) {
//                 return Expanded(
//                   flex: 5,
//                   child: InventoryScreenBody(context, state),
//                 );
//               },
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

// Widget InventoryScreenBody(BuildContext context, InventoryState state) {
//   return BlocConsumer<InventoryBloc, InventoryState>(
//     listener: (context, state) {},
//     builder: (context, state) {
//       if (state.runtimeType != InventoryLoaded) {
//         return Center(
//             child: LoadingAnimationWidget.beat(color: Colors.white, size: 250));
//       }

//       return Padding(
//         padding: const EdgeInsets.only(top: 20.0, left: 20.0),
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 8, mainAxisExtent: 350),
//           itemCount: 8 * 3, // 3 Rows , 9 Columns
//           itemBuilder: (context, index) {
//             return Container(
//                 height: 500,
//                 margin: EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                     color: Colors.grey.withAlpha(35),
//                     border: Border.all(
//                         color: Colors.white.withAlpha(35), width: 2.5),
//                     borderRadius: const BorderRadius.all(Radius.circular(25))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ShelfWidget(
//                       index: index, inventory: (state as InventoryLoaded)),
//                 ));
//           },
//         ),
//       );
//     },
//   );
// }

// class ShelfWidget extends StatelessWidget {
//   final int index;
//   final InventoryLoaded inventory;
//   const ShelfWidget({
//     super.key,
//     required this.index,
//     required this.inventory,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Icon(
//           Icons.medication_sharp,
//           size: 100,
//           color: Color.fromRGBO(2, 104, 187, 1),
//         ),
//         Text("Shelf No. ${index + 1}",
//             style: GoogleFonts.roboto(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             )),
//         //! MEDICATION
//         Row(
//           children: [
//             Text("Medication :",
//                 style: GoogleFonts.roboto(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 107, 107, 107),
//                 )),
//           ],
//         ),
//         DropdownSearch<String>(
//           items: (f, s) => inventory.robotShelfMeds.values.toList(),
//           popupProps: PopupProps.menu(
//             showSearchBox: true,
//           ),
//           selectedItem: inventory.robotShelfMeds[index],
//           decoratorProps: DropDownDecoratorProps(
//               baseStyle: GoogleFonts.roboto(
//             fontSize: 17,
//             fontWeight: FontWeight.bold,
//           )),
//           onChanged: (value) {
//             var newShelves = inventory.robotShelfMeds
//               ..update(
//                 index,
//                 (existingValue) => value!,
//                 ifAbsent: () => value!,
//               );

//             context
//                 .read<InventoryBloc>()
//                 .add(UpdateShelvesEvent(robotShelves: newShelves));
//           },
//         ),
//         //! Quantity
//         SizedBox(
//           height: 10,
//         ),
//         Row(
//           children: [
//             Text("Quantity :",
//                 style: GoogleFonts.roboto(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 107, 107, 107),
//                 )),
//           ],
//         ),
//         DropdownSearch<int>(
//           items: (f, s) => List.generate(20, (index) => index + 1),
//           popupProps: PopupProps.menu(
//             showSearchBox: true,
//           ),
//           selectedItem: inventory.robotShelfQuantity[index],
//           decoratorProps: DropDownDecoratorProps(
//               baseStyle: GoogleFonts.roboto(
//             fontSize: 17,
//             fontWeight: FontWeight.bold,
//           )),
//           onChanged: (value) {
//             var newInventory = inventory.robotShelfQuantity
//               ..update(
//                 index,
//                 (existingValue) => value!,
//                 ifAbsent: () => value!,
//               );

//             context
//                 .read<InventoryBloc>()
//                 .add(UpdateInventoryEvent(robotInventory: newInventory));
//           },
//         ),
//       ],
//     );
//   }
// }
