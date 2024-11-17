import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_park/data/models/order_model.dart';
import 'package:taxi_park/data/repository/data_repo.dart';

part 'orders_state.dart';
part 'orders_event.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({required DataRepo ordersRepository})
      : _ordersRepository = ordersRepository,
        super(const OrdersState()) {
    on<OrdersSubscriptionRequested>(_onOrdersSubscriptionRequested);
  }

  final DataRepo _ordersRepository;

  void _onOrdersSubscriptionRequested(
    OrdersSubscriptionRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    
    await emit.forEach(
      _ordersRepository.orderStream,
      onData: (orders) => state.copyWith(status: OrdersStatus.loaded, orders: orders),
      onError: (_, __) => state.copyWith(status: OrdersStatus.error),
    );
  }
}
