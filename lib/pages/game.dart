import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:misterx/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<Marker> _markers;
  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;

  static const urlTemplate =
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  StoreDirectory cache = FMTC.instance("storeName");

  @override
  void initState() {
    super.initState();
    permsAndGPS();
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double?>();
    _markers = [
      LatLng(47, 11.5),
      LatLng(48.126154762110744, 11.579897939780327), // Munich
      LatLng(49, 11.5),
    ].map(
      (markerPosition) {
        return Marker(
          point: markerPosition,
          width: 40,
          height: 40,
          builder: (_) => const Icon(Icons.location_on, size: 40),
          anchorPos: AnchorPos.align(AnchorAlign.top),
        );
      },
    ).toList();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        child: Scaffold(
      appBar: AppBar(title: const Text('Find Mister X')),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(45, 10),
          zoom: 6,
          maxZoom: 19,
          keepAlive: true,
          interactiveFlags: InteractiveFlag.all ^ InteractiveFlag.rotate,
          // Stop centering the location marker on the map if user interacted with the map.
          onPositionChanged: (MapPosition position, bool hasGesture) {
            if (hasGesture) {
              setState(
                () => _centerOnLocationUpdate = CenterOnLocationUpdate.never,
              );
            }
          },
        ),
        // ignore: sort_child_properties_last
        children: <Widget>[
          TileLayer(
            urlTemplate: urlTemplate,
            subdomains: const ['a', 'b', 'c'],
            maxZoom: 19,
            tileProvider: cache.getTileProvider(),
            userAgentPackageName: 'dev.banana.misterx',
            keepBuffer: 3,
          ),
          MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                  maxClusterRadius: 45,
                  size: const Size(40, 40),
                  anchor: AnchorPos.align(AnchorAlign.center),
                  fitBoundsOptions: const FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                    maxZoom: 15,
                  ),
                  markers: _markers,
                  builder: (context, markers) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue),
                        child: Center(
                          child: Text(
                            markers.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ))),
          CurrentLocationLayer(
            centerCurrentLocationStream:
                _centerCurrentLocationStreamController.stream,
            centerOnLocationUpdate: _centerOnLocationUpdate,
          ),
        ],
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
              source: Uri.parse(urlTemplate).host,
              onSourceTapped: () async =>
                  await launchUrl(Uri.parse("openstreetmap.org/copyright"))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Automatically center the location marker on the map when location updated until user interact with the map.
          setState(
            () => _centerOnLocationUpdate = CenterOnLocationUpdate.always,
          );
          // Center the location marker on the map and zoom the map to level 17.
          _centerCurrentLocationStreamController.add(17);
        },
        child: const Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
    ));
  }

  void permsAndGPS() async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        break;
      case LocationPermission.denied:
        permission = await Geolocator.requestPermission();
        break;
      case LocationPermission.deniedForever:
      case LocationPermission.unableToDetermine:
        await Geolocator.openAppSettings();
        break;
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
    }

    // fail because user
    permission = await Geolocator.checkPermission();
    if (!(permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) ||
        !await Geolocator.isLocationServiceEnabled()) {
      if (!context.mounted) return;
      Navigator.pop(context);
      Utils.msg(context, 'Enable GPS and give permission');
    }
  }
}
