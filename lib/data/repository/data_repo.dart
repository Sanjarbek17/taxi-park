import 'package:taxi_park/core/auth_status.dart';
import 'package:taxi_park/data/models/driver_model.dart';
import 'package:taxi_park/data/models/order_model.dart';
import 'package:taxi_park/data/services/remote_service.dart';

class DataRepo {
  final RemoteService _remoteService;

  DataRepo({required RemoteService remoteService}) : _remoteService = remoteService;


  Future<void> login(String username, String password) async {
    await _remoteService.login(username, password);
  }

  // connect to streams
  Stream<AuthStatus> get authStream => _remoteService.authStream;

  Stream<List<OrderModel>> get orderStream => _remoteService.orderStream;
  Stream<List<DriverModel>> get driverStream => _remoteService.driverStream;
  Stream<List<DriverModel>> get addressStream => _remoteService.addressStream;

  Future<void> logout() async {
    await _remoteService.logout();
  }

  Future<void> getOrders() async {
    await _remoteService.getOrders();
  }

  Future<void> getDrivers() async {
    await _remoteService.getDrivers();
  }

  Future<void> getAddreses() async {
    await _remoteService.getAddresses();
  }
}
