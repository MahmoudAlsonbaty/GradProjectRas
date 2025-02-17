part of 'inventory_bloc.dart';

@immutable
sealed class InventoryEvent {
  const InventoryEvent();
}

final class RefreshInventoryPageEvent extends InventoryEvent {
  const RefreshInventoryPageEvent();
}

final class UpdateInventoryEvent extends InventoryEvent {
  final Map<int, int> robotInventory;
  const UpdateInventoryEvent({required this.robotInventory});
}

final class UpdateShelvesEvent extends InventoryEvent {
  final Map<int, String> robotShelves;
  const UpdateShelvesEvent({required this.robotShelves});
}
