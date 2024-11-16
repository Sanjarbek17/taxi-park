
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressModel {
  String address;
  LatLng coordinates;

  AddressModel({
    required this.address,
    required this.coordinates,
  });
}
