import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:gradproject_management_system/Const/InventoryItem.dart';

// part 'orders_event.dart';
// part 'orders_state.dart';

// Represents a single order containing a list of inventory items
class Order {
  final int orderId;
  final String orderFrom;
  final List<inventoryItem> items;
  const Order({
    required this.orderId,
    this.orderFrom = "Current Pharmacy",
    required this.items,
  });
}

@immutable
sealed class OrdersEvent {
  const OrdersEvent();
}

class AddOrderEvent extends OrdersEvent {
  final Order newOrder;
  const AddOrderEvent({required this.newOrder});
}

class DeleteOrderEvent extends OrdersEvent {
  final int index;
  const DeleteOrderEvent({required this.index});
}

@immutable
sealed class OrdersState {
  const OrdersState();
}

class OrdersLoaded extends OrdersState {
  final List<Order> pendingOrders;
  const OrdersLoaded({required this.pendingOrders});
}

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(const OrdersLoaded(pendingOrders: [])) {
    on<AddOrderEvent>((event, emit) {
      final currentOrders =
          List<Order>.from((state as OrdersLoaded).pendingOrders);
      currentOrders.add(event.newOrder);
      print("gggggggggggg " +
          currentOrders.length.toString() +
          " " +
          event.newOrder.items.toString());
      emit(OrdersLoaded(pendingOrders: currentOrders));
    });
    on<DeleteOrderEvent>((event, emit) {
      final currentOrders =
          List<Order>.from((state as OrdersLoaded).pendingOrders);
      if (event.index >= 0 && event.index < currentOrders.length) {
        currentOrders.removeAt(event.index);
      }
      emit(OrdersLoaded(pendingOrders: currentOrders));
    });
  }
}
