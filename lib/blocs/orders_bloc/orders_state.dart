part of 'orders_bloc.dart';

@immutable
sealed class OrdersState {
  const OrdersState();
}

final class OrdersUpdated extends OrdersState {
  final List<ORDER> pendingOrders;
  const OrdersUpdated({required this.pendingOrders});
}
