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
    await _dio.post(
      '/logout',
      options: Options(
        headers: {
          'X-Auth': _sharedPreferences.getString(token),
          'x-brigadier-site': 'taxi-kp.tm.taxi',
        },
      ),
    );
    await _sharedPreferences.remove(token);
    _authStreamController.add(AuthStatus.unauthenticated);
  }

  Future<void> getOrders({int pageLimit = 24}) async {
    final now = DateTime.now();
    try {
      final response = await _dio.get(
        '/orders',
        options: Options(
          headers: {
            'X-Auth': _sharedPreferences.getString(token),
            'x-brigadier-site': 'taxi-kp.tm.taxi',
          },
        ),
        queryParameters: {
          'page[limit]': pageLimit,
          'filter[finished][gte]': DateTime(now.year, now.month, now.day).toIso8601String(),
          'filter[finished][lte]': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          'fields[orders]': 'id,addresses,created,finished,state,car,driver,cost',
          'fields[drivers]': 'state,name,car,crew_group,balance,phones,online,call,comment,blocked,block_reason,available_cars',
        },
      );

      final orders = response.data['data'] as List;
      final included = response.data['included'] as List;
      final ordersModel = orders
          .map(
            (order) => OrderModel.fromJson(
              order,
              included,
            ),
          )
          .toList();
      _orderStreamController.add(ordersModel);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _sharedPreferences.remove(token);
        _authStreamController.add(AuthStatus.unauthenticated);
      }
    }
  }

  Future<void> getDrivers() async {
    try {
      final response = await _dio.get(
        '/drivers',
        options: Options(headers: {
          'X-Auth': _sharedPreferences.getString(token),
          'x-brigadier-site': 'taxi-kp.tm.taxi',
        }),
        queryParameters: {
          'fields[drivers]': 'state,name,car,crew_group,balance,phones,online,call,comment,blocked,block_reason,available_cars',
          'include': 'car,car.attributes,available_cars,crew_group,undefined',
          'page[limit]': 25,
        },
      );
      final drivers = response.data['data'] as List;
      final included = response.data['included'] as List;
      final driversModel = drivers.map((driver) => DriverModel.fromJson(driver, included)).toList();
      _driverStreamController.add(driversModel);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _sharedPreferences.remove(token);
        _authStreamController.add(AuthStatus.unauthenticated);
      }
    }
  }

  Future<void> getAddresses({int pageLimit = 24}) async {
    final now = DateTime.now();
    try {
      final response = await _dio.get(
        '/orders',
        options: Options(headers: {
          'X-Auth': _sharedPreferences.getString(token),
          'x-brigadier-site': 'taxi-kp.tm.taxi',
        }),
        queryParameters: {
          'page[limit]': pageLimit,
          'filter[finished][gte]': DateTime(now.year, now.month, now.day).toIso8601String(),
          'filter[finished][lte]': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          'fields[orders]': 'id,addresses,created,finished,state,car,driver,cost',
          'fields[drivers]': 'state,name,car,crew_group,balance,phones,online,call,comment,blocked,block_reason,available_cars,coordinates',
        },
      );
      // print(response.data);
      final included = response.data['included'] as List;
      final drivers = included.where((element) => element['type'] == 'drivers').toList();
      final addresses = drivers.map((driver) => DriverModel.fromJson(driver)).toList();
      _addressStreamController.add(addresses);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _sharedPreferences.remove(token);
        _authStreamController.add(AuthStatus.unauthenticated);
      } else {
      }
    }
  }
}
