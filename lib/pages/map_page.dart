import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(39.763594, 67.272534), // Center the map over London
        initialZoom: 13.2,
        minZoom: 10.5,
        interactionOptions: InteractionOptions(
          // make the map not rotate when zooming

          flags: InteractiveFlag.doubleTapDragZoom | InteractiveFlag.doubleTapZoom | InteractiveFlag.drag | InteractiveFlag.flingAnimation | InteractiveFlag.pinchZoom | InteractiveFlag.scrollWheelZoom,
        ),
      ),
      children: [
        TileLayer(
          // Display map tiles from any source
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
          userAgentPackageName: 'com.example.app',
          // And many more recommended properties!
        ),
        // const MarkerLayer(
        //   markers: [
        //     Marker(
        //       point: LatLng(39.763594, 67.272534),
        //       width: 80,
        //       height: 80,
        //       child: Icon(Icons.location_on, size: 40, color: Colors.red),
        //     ),
        //   ],
        // ),
        PopupMarkerLayer(
          options: PopupMarkerLayerOptions(
            markers: [
              const Marker(
                point: LatLng(39.763594, 67.272534),
                width: 80,
                height: 80,
                child: Icon(Icons.location_on, size: 40, color: Colors.red),
              ),
            ],
            // popupController: PopupController(),
            popupDisplayOptions: PopupDisplayOptions(
              builder: (context, marker) {
                return CustomPopUp(marker: marker);
              },
            ),
          ),
        ),
        RichAttributionWidget(
          // Include a stylish prebuilt attribution widget that meets all requirments
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
            ),
            // Also add images...
          ],
        ),
      ],
    );
  }
}

class CustomPopUp extends StatelessWidget {
  final Marker marker;
  const CustomPopUp({
    super.key,
    required this.marker,
  });

  @override
  Widget build(BuildContext context) {
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
              "full name: Po'latov Akmal O'talboy o'g'li",
              "alias: 18463",
              "cab group: Булунгур",
              "balance on account: RUB 11,490",
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
