import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:taxi_park/core/custom_marker.dart';
import 'package:taxi_park/data/models/driver_model.dart';

class CustomPopUp extends StatelessWidget {
  final Marker marker;
  const CustomPopUp({
    super.key,
    required this.marker,
  });

  @override
  Widget build(BuildContext context) {
    DriverModel driver;
    driver = (marker as CustomMarker).driver;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              "full name: ${driver.name}",
              "alias: ${driver.id}",
              "phoneNumber: ${driver.phoneNumber}",
              "balance on account: RUB ${driver.balance}",
            ]
                .map(
                  (e) => Text(
                    e,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
