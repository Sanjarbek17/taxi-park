import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_park/data/models/driver_model.dart';
import 'package:taxi_park/data/models/order_model.dart';
import 'package:taxi_park/data/repository/data_repo.dart';

part 'data_bloc_state.dart';
part 'data_bloc_event.dart';

class DataBloc extends Bloc<DataBlocEvent, DataBlocState> {
  DataBloc({required DataRepo ordersRepository})
      : _ordersRepository = ordersRepository,
        super(const DataBlocState()) {
    on<OrdersSubscriptionRequested>(_onOrdersSubscriptionRequested);
    on<DriversSubscriptionRequested>(_onDriversSubscriptionRequested);
    on<AddressesSubscriptionRequested>(_onAddressesSubscriptionRequested);
  }

  final DataRepo _ordersRepository;



  void _onOrdersSubscriptionRequested(
    OrdersSubscriptionRequested event,
    Emitter<DataBlocState> emit,
  ) async {
    emit(state.copyWith(status: DataStatus.loading));
    
    await emit.forEach(
      _ordersRepository.orderStream,
      onData: (orders) => state.copyWith(status: DataStatus.loaded, orders: orders),
      onError: (_, __) => state.copyWith(status: DataStatus.error),
    );
  }

  void _onDriversSubscriptionRequested(
    DriversSubscriptionRequested event,
    Emitter<DataBlocState> emit,
  ) async {
    emit(state.copyWith(status: DataStatus.loading));
    
    await emit.forEach(
      _ordersRepository.driverStream,
      onData: (drivers) => state.copyWith(status: DataStatus.loaded, drivers: drivers),
      onError: (_, __) => state.copyWith(status: DataStatus.error),
    );
  }

  void _onAddressesSubscriptionRequested(
    AddressesSubscriptionRequested event,
    Emitter<DataBlocState> emit,
  ) async {
    emit(state.copyWith(status: DataStatus.loading));
    
    await emit.forEach(
      _ordersRepository.addressStream,
      onData: (addresses) => state.copyWith(status: DataStatus.loaded, addresses: addresses),
      onError: (_, __) => state.copyWith(status: DataStatus.error),
    );
  }
  
}
