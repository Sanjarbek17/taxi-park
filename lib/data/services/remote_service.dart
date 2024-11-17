import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_park/data/models/order_model.dart';

class RemoteService {
  final SharedPreferences _sharedPreferences;
  final Dio _dio;

  static const token = 'token';

  RemoteService({required SharedPreferences sharedPreferences, required Dio dio})
      : _sharedPreferences = sharedPreferences,
        _dio = dio;

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

  Future<List<OrderModel>> getOrders({int pageLimit=10}) async {
    final response = await _dio.get(
      '/orders',
      options: Options(
        headers: {
          'X-Auth': _sharedPreferences.getString(token),
          'x-brigadier-site': 'taxi-kp.tm.taxi',
        }
      ),
      queryParameters: {
        'page[limit]': pageLimit,
        'filter[finished][gte]': DateTime.now().toIso8601String(),
        'filter[finished][lte]': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        'fields[orders]': 'id,addresses,created,finished,state,car,driver,cost',
      }
    );
    final orders = response.data['data'] as List;
    final included = response.data['included'] as List;
    return orders.map((order) => OrderModel.fromJson(order, included)).toList();
  }
}
