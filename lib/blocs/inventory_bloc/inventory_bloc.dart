import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

//Shelf : Medicine Name Present in Shelf
var RobotShelfMeds = {
  0: "Example 1",
  1: "Example 2",
  2: "Example 3",
  3: "Example 4",
  4: "Example 5",
  5: "Example 6",
  6: "Example 7",
  7: "Example 8",
  8: "Example 9",
  9: "Example 9",
  10: "Example 9",
  11: "Example 9",
  12: "Example 9",
  13: "Example 9",
  14: "Example 9",
  15: "Example 9",
  16: "Example 9",
  17: "Example 9",
  18: "Example 9",
  19: "Example 9",
  20: "Example 9",
  21: "Example 9",
  22: "Example 9",
  23: "Example 9",
  24: "Example 9",
};

//Shelf : Quantity Present in Shelf
var RobotShelfQuantity = {
  0: 0,
  1: 1,
  2: 2,
  3: 3,
  4: 1,
  5: 1,
  6: 1,
  7: 1,
  8: 1,
  9: 1,
  10: 6,
  11: 6,
  12: 6,
  13: 6,
  14: 6,
  15: 6,
  16: 6,
  17: 6,
  18: 6,
  19: 6,
  20: 6,
  21: 6,
  22: 6,
  23: 6,
  24: 6,
};

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc()
      : super(InventoryLoaded(
            robotShelfQuantity: RobotShelfQuantity,
            robotShelfMeds: RobotShelfMeds)) {
    on<RefreshInventoryPageEvent>((event, emit) {
      emit(InventoryLoaded(
          robotShelfQuantity: RobotShelfQuantity,
          robotShelfMeds: RobotShelfMeds));
    });
    on<UpdateInventoryEvent>((event, emit) {
      var eventRobotInventory = event.robotInventory;
      emit(InventoryLoaded(
          robotShelfQuantity: eventRobotInventory,
          robotShelfMeds: RobotShelfMeds));
    });
    on<UpdateShelvesEvent>((event, emit) {
      var eventRobotShelves = event.robotShelves;
      emit(InventoryLoaded(
          robotShelfQuantity: RobotShelfQuantity,
          robotShelfMeds: eventRobotShelves));
    });
  }
}
