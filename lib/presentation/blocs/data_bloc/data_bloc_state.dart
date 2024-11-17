part of 'data_bloc.dart';


enum DataStatus { initial, loading, loaded, error }

class DataBlocState extends Equatable {
  const DataBlocState({
    this.status = DataStatus.initial,
    this.driverStatus = DataStatus.initial,
    this.addressStatus = DataStatus.initial,
    this.orders = const <OrderModel>[],
    this.drivers = const <DriverModel>[],
    this.addresses = const <DriverModel>[],
  });

  final DataStatus status;
  final DataStatus driverStatus;
  final DataStatus addressStatus;
  final List<OrderModel> orders;
  final List<DriverModel> drivers;
  final List<DriverModel> addresses;
  

  DataBlocState copyWith({
    DataStatus? status,
    DataStatus? driverStatus,
    DataStatus? addressStatus,
    List<OrderModel>? orders,
    List<DriverModel>? drivers,
    List<DriverModel>? addresses,
  }) {
    return DataBlocState(
      status: status ?? this.status,
      driverStatus: driverStatus ?? this.driverStatus,
      addressStatus: addressStatus ?? this.addressStatus,
      orders: orders ?? this.orders,
      drivers: drivers ?? this.drivers,
      addresses: addresses ?? this.addresses,
    );
  }

  @override
  List<Object> get props => [status, driverStatus, addressStatus, orders, drivers, addresses];
}