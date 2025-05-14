part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {
  const InventoryState();
}

final class InventoryLoaded extends InventoryState {
  final List<inventoryItem> inventoryItems;
  const InventoryLoaded({required this.inventoryItems});

  @override
  String toString() {
    return 'InventoryLoaded, inventoryItems: $inventoryItems}';
  }
}

final class InventorySearched extends InventoryState {
  final List<inventoryItem> inventoryItems;
  final String searchTerm;
  const InventorySearched(
      {required this.inventoryItems, required this.searchTerm});

  @override
  String toString() {
    return 'InventorySearched, inventoryItems: $inventoryItems}';
  }
}
