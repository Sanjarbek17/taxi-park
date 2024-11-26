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
    on<DriversSearchRequested>(_onDriversSearchRequested);
    on<PickedDateOrdersRange>(_onPickedDateOrdersRange);
  }

  final DataRepo _ordersRepository;

  void _onOrdersSubscriptionRequested(
    OrdersSubscriptionRequested event,
    Emitter<DataBlocState> emit,
  ) async {
    emit(state.copyWith(status: DataStatus.loading));
    await _ordersRepository.getOrders();
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
    emit(state.copyWith(driverStatus: DataStatus.loading));
    _ordersRepository.getDrivers();
    await emit.forEach(
      _ordersRepository.driverStream,
      onData: (drivers) => state.copyWith(driverStatus: DataStatus.loaded, drivers: drivers),
      onError: (_, __) => state.copyWith(driverStatus: DataStatus.error),
    );
  }

  void _onAddressesSubscriptionRequested(
    AddressesSubscriptionRequested event,
    Emitter<DataBlocState> emit,
  ) async {
    emit(state.copyWith(addressStatus: DataStatus.loading));
    _ordersRepository.getAddreses();
    await emit.forEach(
      _ordersRepository.addressStream,
      onData: (addresses) => state.copyWith(addressStatus: DataStatus.loaded, addresses: addresses),
      onError: (_, __) => state.copyWith(addressStatus: DataStatus.error),
    );
  }

  void _onDriversSearchRequested(
    DriversSearchRequested event,
    Emitter<DataBlocState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(driverStatus: DataStatus.loaded, searchDrivers: const <DriverModel>[]));
      return;
    }
    final filteredDrivers = state.drivers.where((driver) {
      return driver.name.toLowerCase().contains(event.query);
    }).toList();
    emit(state.copyWith(driverStatus: DataStatus.searching, searchDrivers: filteredDrivers));
  }

  void _onPickedDateOrdersRange(
    PickedDateOrdersRange event,
    Emitter<DataBlocState> emit,
  ) async {
    final orders = await _ordersRepository.getOrdersByDateRange(event.startDate, event.endDate);
    emit(state.copyWith(status: DataStatus.searching, searchOrders: orders));
  }
}
