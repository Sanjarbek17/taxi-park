import 'package:dio/dio.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_park/data/models/driver_model.dart';
import 'package:taxi_park/data/models/order_model.dart';

class RemoteService {
  final SharedPreferences _sharedPreferences;
  final Dio _dio;

  static const token = 'token';

  RemoteService({
    required SharedPreferences sharedPreferences,
    required Dio dio,
  })  : _sharedPreferences = sharedPreferences,
        _dio = dio;

  late final _orderStreamController = BehaviorSubject<List<OrderModel>>.seeded([]);
  late final _driverStreamController = BehaviorSubject<List<DriverModel>>.seeded([]);
  late final _addressStreamController = BehaviorSubject<List<DriverModel>>.seeded([]);

  Stream<List<OrderModel>> get orderStream => _orderStreamController.asBroadcastStream();
  Stream<List<DriverModel>> get driverStream => _driverStreamController.asBroadcastStream();
  Stream<List<DriverModel>> get addressStream => _addressStreamController.asBroadcastStream();

  Future<void> login(String username, String password) async {
    final response = await _dio.post('/login', queryParameters: {
      'username': username,
      'password': password,
    });

    final authToken = response.data['auth_token'];
    await _sharedPreferences.setString(token, authToken);
  }

  Future<void> logout() async {
    await _dio.post('/logout');
    await _sharedPreferences.remove(token);
  }

  Future<void> getOrders({int pageLimit = 10}) async {
    final response = await _dio.get('/orders',
        options: Options(headers: {
          'X-Auth': _sharedPreferences.getString(token),
          'x-brigadier-site': 'taxi-kp.tm.taxi',
        }),
        queryParameters: {
          'page[limit]': pageLimit,
          'filter[finished][gte]': DateTime.now().toIso8601String(),
          'filter[finished][lte]': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          'fields[orders]': 'id,addresses,created,finished,state,car,driver,cost',
        });
    final orders = response.data['data'] as List;
    final included = response.data['included'] as List;
    final ordersModel = orders.map((order) => OrderModel.fromJson(order, included)).toList();
    _orderStreamController.add(ordersModel);
  }

  Future<void> getDrivers() async {
    final response = await _dio.get('/drivers',
        options: Options(headers: {
          'X-Auth': _sharedPreferences.getString(token),
          'x-brigadier-site': 'taxi-kp.tm.taxi',
        }),
        queryParameters: {
          'fields[drivers]': 'state,name,car,crew_group,balance,phones,online,call,comment,blocked,block_reason,available_cars',
          'include': 'car,car.attributes,available_cars,crew_group,undefined',
          'filter[state_type]': 'on_order',
          'page[limit]': 5,
        });
    final drivers = response.data['data'] as List;
    final included = response.data['included'] as List;
    final driversModel = drivers.map((driver) => DriverModel.fromJson(driver, included)).toList();
    _driverStreamController.add(driversModel);
  }

  Future<void> getAddresses() async {
    final response = await _dio.get('/orders',
        options: Options(headers: {
          'X-Auth': _sharedPreferences.getString(token),
          'x-brigadier-site': 'taxi-kp.tm.taxi',
        }),
        queryParameters: {
          'fields[drivers]': 'state,name,car,crew_group,balance,phones,online,call,comment,blocked,block_reason,available_cars',
          'include': 'car,car.attributes,available_cars,crew_group,undefined',
          'filter[state_type]': 'on_order',
          'page[limit]': 5,
        });
    final included = response.data['included'] as List;
    final addresses = included.map((driver) => DriverModel.fromJson(driver)).toList();
    _addressStreamController.add(addresses);
  }
}
