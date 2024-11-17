
import 'package:flutter_map/flutter_map.dart';
import 'package:taxi_park/data/models/driver_model.dart';

class CustomMarker extends Marker {
  final DriverModel driver;
  const CustomMarker({
    required this.driver,
    required super.point,
    required super.width,
    required super.height,
    required super.child,
  });
}
