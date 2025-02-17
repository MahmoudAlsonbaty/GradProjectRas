import 'package:bloc/bloc.dart';
import 'package:gradproject_management_system/Const/order.dart';
import 'package:meta/meta.dart';

part 'orders_event.dart';
part 'orders_state.dart';

List<ORDER> exampleOfPendingList = [
  ORDER(requestsList: [
    REQUEST(medicineName: "Paracetamol 50ml", orderQuantity: 2, shelfNo: 5),
    REQUEST(medicineName: "Vitamin D 50ml", orderQuantity: 3, shelfNo: 2),
  ])
];

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersUpdated(pendingOrders: exampleOfPendingList)) {
    on<AddOrderEvent>((event, emit) {
      //! TODO: Check This
      emit(OrdersUpdated(
          pendingOrders: (state as OrdersUpdated).pendingOrders
            ..add(event.newOrder)));
    });
    on<DeleteOrderEvent>((event, emit) {
      var newPending = (state as OrdersUpdated).pendingOrders;
      newPending.removeAt(event.number);
      emit(OrdersUpdated(pendingOrders: newPending));
    });
  }
}
