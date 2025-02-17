part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {
  const InventoryState();
}

final class InventoryLoaded extends InventoryState {
  final Map<int, int> robotShelfQuantity;
  final Map<int, String> robotShelfMeds;
  const InventoryLoaded(
      {required this.robotShelfQuantity, required this.robotShelfMeds});

  @override
  String toString() {
    String toBePrinted = "";

    toBePrinted += "Shelves(Medicine) : \n";
    robotShelfMeds.forEach((key, value) =>
        {toBePrinted += "Shelf No.${key + 1}($key) has ${value}\n"});

    toBePrinted += "Quantities(Inventory) : \n";
    robotShelfQuantity.forEach((key, value) =>
        {toBePrinted += "Shelf No.${key + 1}($key) has ${value}\n"});

    return toBePrinted;
  }
}
