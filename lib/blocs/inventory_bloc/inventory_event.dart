part of 'inventory_bloc.dart';

@immutable
sealed class InventoryEvent {
  const InventoryEvent();
}

final class RefreshInventoryContentEvent extends InventoryEvent {
  const RefreshInventoryContentEvent();
}

final class InventorySearchEvent extends InventoryEvent {
  final String searchTerm;
  const InventorySearchEvent({required this.searchTerm});
}

final class UpdateInventoryEvent extends InventoryEvent {
  final Map<int, int> robotInventory;
  const UpdateInventoryEvent({required this.robotInventory});
}

final class UpdateShelvesEvent extends InventoryEvent {
  final Map<int, String> robotShelves;
  const UpdateShelvesEvent({required this.robotShelves});
}

final class FetchInventoryFromCloudEvent extends InventoryEvent {
  const FetchInventoryFromCloudEvent();
}

final class UpdateInventoryInCloudEvent extends InventoryEvent {
  final List<inventoryItem> inventoryItems;
  const UpdateInventoryInCloudEvent({required this.inventoryItems});
}

final class UpdateSingleInventoryItemEvent extends InventoryEvent {
  final inventoryItem updatedItem;
  const UpdateSingleInventoryItemEvent({required this.updatedItem});
}
