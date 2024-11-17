import 'package:taxi_park/data/models/car_model.dart';

class DriverModel {
  int id;
  String name;
  int balance;
  bool online;
  String phoneNumber;
  CarModel? carId;

  DriverModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.online,
    required this.phoneNumber,
    this.carId,
  });

  factory DriverModel.fromJson(Map<String, dynamic> data, List included) {
    final json = data['attributes'];
    final carId = data['relationships']['car']['data']['id'];
    return DriverModel(
      id: data['id'],
      name: json['name'],
      balance: json['balance'],
      online: json['online'],
      phoneNumber: json['phones'].first['number'],
      carId: CarModel.fromJson(
        included.firstWhere(
          (element) => element['type'] == 'cars' && element['id'] == carId,
        ),
      ),
    );
  }
}
