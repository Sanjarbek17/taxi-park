import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_park/core/custom_marker.dart';
import 'package:taxi_park/presentation/blocs/data_bloc/data_bloc.dart';
import 'package:taxi_park/presentation/widgets/marker_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final PopupController _pageController = PopupController();
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
        BlocBuilder<DataBloc, DataBlocState>(
          builder: (context, state) {
            return PopupMarkerLayer(
              options: PopupMarkerLayerOptions(
                markers: state.addresses.map(
                  (driver) {
                    return CustomMarker(
                      driver: driver,
                      point: driver.address ?? const LatLng(0, 0),
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.location_on,
                        size: 40,
                        color: driver.status == 'waiting'
                            ? Colors.green
                            : driver.status == 'not_available'
                                ? Colors.black
                                : Colors.red,
                      ),
                    );
                  },
                ).toList(),
                popupController: _pageController,
                popupDisplayOptions: PopupDisplayOptions(
                  builder: (context, marker) {
                    return TapRegion(
                        onTapOutside: (event) {
                          _pageController.hideAllPopups();
                        },
                        child: CustomPopUp(marker: marker));
                  },
                ),
                // selectedMarkerBuilder: (context, marker) {
                //   return CustomPopUp(marker: marker);
                // },
              ),
            );
          },
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
