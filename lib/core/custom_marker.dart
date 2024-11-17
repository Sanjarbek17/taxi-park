import 'package:flutter_map/flutter_map.dart';

class CustomMarker extends Marker {
  final dynamic driver;
  const CustomMarker({
    required this.driver,
    required super.point,
    required super.width,
    required super.height,
    required super.child,
  });
}