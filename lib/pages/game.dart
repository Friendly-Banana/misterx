import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_tile_caching/fmtc_advanced.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:misterx/utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const double nearZoom = 17;
  static final LatLng munich = LatLng(48.126154762110744, 11.579897939780327);
  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;
  MapController map = MapController();

  static const urlTemplate =
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  late FMTCTileProvider tileProvider;
  late Future<List<dynamic>> loaded;

  late final Timer refresh;

  @override
  void initState() {
    super.initState();
    loaded = Future.wait([permsAndGPS(), setupCache()]);
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double?>();
    refresh = Timer.periodic(const Duration(seconds: 10), (timer) {
      Provider.of<API>(context, listen: false).updatePlayers();
      Geolocator.getCurrentPosition().then((pos) =>
          Provider.of<API>(context, listen: false).sendLocalPlayerPos(pos));
    });
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    refresh.cancel();
    super.dispose();
  }

  Marker createMarker(Player player) => Marker(
        point: player.pos!,
        width: 40,
        height: 40,
        builder: (_) => IconButton(
            onPressed: () => print("hi"),
            icon: Icon(Icons.location_on,
                size: 40, color: player.mrX ? Colors.red : Colors.black)),
        anchorPos: AnchorPos.align(AnchorAlign.top),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<API>(
      builder: (context, api, child) => Scaffold(
        appBar: AppBar(
            title: const Text('Find Mister X'),
            automaticallyImplyLeading: false,
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.people),
                  tooltip: "Find player",
                );
              }),
              IconButton(
                onPressed: () {
                  api.finish();
                },
                icon: const Icon(Icons.flag),
                tooltip: "End the game",
              )
            ]),
        drawer: Drawer(child: Builder(builder: (context) {
          return ListView(
            children: api.player
                .map((player) => ListTile(
                      leading: Icon(player.mrX ? Icons.close : Icons.person),
                      title: Text(player.name),
                      subtitle: Utils.distanceText(api.localPlayer, player),
                      onTap: () {
                        if (player.pos != null) {
                          Scaffold.of(context).closeDrawer();
                          map.move(player.pos!, nearZoom);
                          setState(() {
                            _centerOnLocationUpdate =
                                CenterOnLocationUpdate.never;
                          });
                        }
                      },
                    ))
                .toList()
              ..insert(0, const ListTile(title: Text("Player"))),
          );
        })),
        body: FutureBuilder(
          future: loaded,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return FlutterMap(
                mapController: map,
                options: MapOptions(
                  center: munich,
                  zoom: 6,
                  maxZoom: 19,
                  keepAlive: true,
                  interactiveFlags:
                      InteractiveFlag.all ^ InteractiveFlag.rotate,
                  // Stop centering the location marker on the map if user interacted with the map.
                  onPositionChanged: (MapPosition position, bool hasGesture) {
                    if (hasGesture) {
                      setState(
                        () => _centerOnLocationUpdate =
                            CenterOnLocationUpdate.never,
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
                    tileProvider: tileProvider,
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
                          markers: api.player
                              .where((player) =>
                                  player.id != api.localPlayerID &&
                                  player.pos != null)
                              .map(createMarker)
                              .toList(),
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
                  attribution(() =>
                      launchUrl(Uri.parse("openstreetmap.org/copyright"))),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Automatically center the location marker on the map when location updated until user interact with the map.
            setState(
              () => _centerOnLocationUpdate = CenterOnLocationUpdate.always,
            );
            // Center the location marker on the map and zoom the map.
            _centerCurrentLocationStreamController.add(nearZoom);
          },
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }

  Widget attribution(void Function()? onSourceTapped) {
    /*AttributionWidget.defaultWidget(
                    source: "OpenStreetMap",
                    onSourceTapped: () =>
                        launchUrl(Uri.parse("openstreetmap.org/copyright")),
                  )*/
    TextStyle sourceTextStyle = const TextStyle(color: Color(0xFF0078a8));
    Alignment alignment = Alignment.bottomRight;
    return Align(
      alignment: alignment,
      child: ColoredBox(
        color: const Color(0xCCFFFFFF),
        child: GestureDetector(
          onTap: onSourceTapped,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: MouseRegion(
              cursor: onSourceTapped == null
                  ? MouseCursor.defer
                  : SystemMouseCursors.click,
              child: Text(
                "© OpenStreetMap",
                style: onSourceTapped == null ? null : sourceTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> permsAndGPS() async {
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
      if (!mounted) return;
      Navigator.pop(context);
      Utils.msg(context, 'Enable GPS and give permission');
    }
  }

  Future<void> setupCache() async {
    var rootDirectory = await RootDirectory.normalCache;
    tileProvider = FlutterMapTileCaching.initialise(rootDirectory)["munich"]
        .getTileProvider();
  }
}
