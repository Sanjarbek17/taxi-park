import 'package:taxi_park/data/models/address_model.dart';

class OrderModel {
  int id;
  DateTime created;
  DateTime finished;
  List<AddressModel> addresses;
  String status;
  int cash;
  String crewGroup;
  // TODO: this must driver model
  int driverId;
  // TODO: this must car model
  int carId;

  OrderModel({
    required this.id,
    required this.created,
    required this.finished,
    required this.addresses,
    required this.status,
    required this.cash,
    required this.driverId,
    required this.carId,
    required this.crewGroup,
  });
}
