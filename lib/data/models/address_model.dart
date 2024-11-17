import 'package:latlong2/latlong.dart';

class AddressModel {
  final DateTime dateCoordinates;
  final LatLng coordinates;

  AddressModel({
    required this.dateCoordinates,
    required this.coordinates,
  });
}
