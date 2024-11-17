part of 'orders_bloc.dart';


enum OrdersStatus { initial, loading, loaded, error }

class OrdersState extends Equatable {
  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const <OrderModel>[],
  });

  final OrdersStatus status;
  final List<OrderModel> orders;

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderModel>? orders,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object> get props => [status, orders];
}