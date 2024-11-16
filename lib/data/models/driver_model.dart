import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverModel {
  int id;
  String name;
  int balance;
  bool online;
  String state;
  String phoneNumber;
  // TODO: this must car model
  int carId;
  // coordinates
  DateTime dateCoordinates;
  LatLng coordinates;

  DriverModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.online,
    required this.state,
    required this.phoneNumber,
    required this.carId,
    required this.dateCoordinates,
    required this.coordinates,
  });
}
