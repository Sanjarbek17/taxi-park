part of 'data_bloc.dart';


enum DataStatus { initial, loading, loaded, error }

class DataBlocState extends Equatable {
  const DataBlocState({
    this.status = DataStatus.initial,
    this.orders = const <OrderModel>[],
    this.drivers = const <DriverModel>[],
    this.addresses = const <DriverModel>[],
  });

  final DataStatus status;
  final List<OrderModel> orders;
  final List<DriverModel> drivers;
  final List<DriverModel> addresses;
  

  DataBlocState copyWith({
    DataStatus? status,
    List<OrderModel>? orders,
    List<DriverModel>? drivers,
    List<DriverModel>? addresses,
  }) {
    return DataBlocState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      drivers: drivers ?? this.drivers,
      addresses: addresses ?? this.addresses,
    );
  }

  @override
  List<Object> get props => [status, orders, drivers, addresses];
}