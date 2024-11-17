import 'package:taxi_park/data/models/driver_model.dart';

class OrderModel {
  int id;
  DateTime created;
  DateTime finished;
  List<String> addresses;
  String status;
  int cash;
  DriverModel driverId;

  OrderModel({
    required this.id,
    required this.created,
    required this.finished,
    required this.addresses,
    required this.status,
    required this.cash,
    required this.driverId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> data, List included) {
    int driverId = data['relationships']['driver']['data']['id'];
    final json = data['attributes'];
    return OrderModel(
      id: json['id'],
      created: DateTime.parse(json['created']),
      finished: DateTime.parse(json['finished']),
      addresses: List<String>.from(
        (json['addresses'] as List)
            .map(
              (address) => address['address'],
            ),
      ),
      status: json['status'],
      cash: json['cash'],
      driverId: DriverModel.fromJson(
        included.firstWhere(
          (element) => element['type'] == 'drivers' && element['id'] == driverId,
        
        ),
        included,
      ),
    );
  }
}
