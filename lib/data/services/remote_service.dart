import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_park/core/auth_status.dart';
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

  late final _authStreamController = StreamController<AuthStatus>();

  late final _orderStreamController = BehaviorSubject<List<OrderModel>>.seeded([]);
  late final _driverStreamController = BehaviorSubject<List<DriverModel>>.seeded([]);
  late final _addressStreamController = BehaviorSubject<List<DriverModel>>.seeded([]);

  Stream<AuthStatus> get authStream async* {
    final token = _sharedPreferences.getString(RemoteService.token);
    if (token != null) {
      yield AuthStatus.authenticated;
    } else {
      yield AuthStatus.unauthenticated;
    }
    yield* _authStreamController.stream;
  }

  Stream<List<OrderModel>> get orderStream => _orderStreamController.asBroadcastStream();
  Stream<List<DriverModel>> get driverStream => _driverStreamController.asBroadcastStream();
  Stream<List<DriverModel>> get addressStream => _addressStreamController.asBroadcastStream();

  Future<void> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-brigadier-site': 'taxi-kp.tm.taxi',
          },
        ),
        queryParameters: {
          'login': username,
          'password': password,
        },
      );
      final authToken = response.data['auth_token'];
      await _sharedPreferences.setString(token, authToken);
      _authStreamController.add(AuthStatus.authenticated);
    } catch (_) {
      _authStreamController.add(AuthStatus.unauthenticated);
      throw Exception('Invalid credentials');
    }
  }

  Future<void> logout() async {
    await _dio.post('/logout');
    await _sharedPreferences.remove(token);
    _authStreamController.add(AuthStatus.unauthenticated);
  }

  Future<void> getOrders({int pageLimit = 10}) async {
    final now = DateTime.now();
    final response = await _dio.get('/orders',
        options: Options(headers: {
          'X-Auth': _sharedPreferences.getString(token),
          'x-brigadier-site': 'taxi-kp.tm.taxi',
        }),
        queryParameters: {
          'page[limit]': pageLimit,
          'filter[finished][gte]': DateTime(now.year, now.month, now.day).toIso8601String(),
          'filter[finished][lte]': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          'fields[orders]': 'id,addresses,created,finished,state,car,driver,cost',
        });
    // print(response.data);
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
