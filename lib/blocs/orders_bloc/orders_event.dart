part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {
  const OrdersEvent();
}

final class AddOrderEvent extends OrdersEvent {
  final ORDER newOrder;
  const AddOrderEvent({required this.newOrder});
}

final class DeleteOrderEvent extends OrdersEvent {
  final int number;
  const DeleteOrderEvent({required this.number});
}
