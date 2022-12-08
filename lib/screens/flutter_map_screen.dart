import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nows_app/cards/attribution_card.dart';

import '../widgets/location_fab.dart';
import '../widgets/map_screen_fab.dart';
import '../widgets/postmarker_builder.dart';
import '../widgets/app_bar.dart';

// API keys
import '../env/env.dart';

class FlutterMapScreen extends StatefulWidget {
  const FlutterMapScreen({super.key});

  @override
  State<FlutterMapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<FlutterMapScreen> with TickerProviderStateMixin{

  DatabaseReference postLocationRef = FirebaseDatabase.instance.ref().child("location_data");
  late final MapController _mapController;

  String locationSnapshot = '';
  Future<Position>? _initialLocation;

  List<Marker> markerList = <Marker>[];

  bool _isLight = false;
  String tileStyle = "clatumvh9008x14ktr37ooyxw";
  Color _backgroundColor = Colors.grey.shade900;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    _initialLocation = currentLocation();

  }

  @override
  void dispose() {
    super.dispose();
  }

  void updatePostMarkerList() {
    postLocationRef.onChildAdded.listen((event) { 

      var markerLocation = LatLng(
        double.parse(event.snapshot.child("lat").value.toString()), 
        double.parse(event.snapshot.child("lng").value.toString()));

      var markerId = event.snapshot.key!;

      setState(() {
        markerList.add(Marker(
          key: ValueKey(markerId),
          point: markerLocation,
          builder: (context) {
            return MarkerBuilder(
              moveToMarker: animatedMapMove, 
              markerLocation: markerLocation,
              markerId: markerId,
            );
          },
        ));
      });

      print("POST MARKER ADDED TO LIST! TOTAL: ${markerList.length}");

    });
  }

  Future<Position> currentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  centerOnLocation() async {
    var location = await Geolocator.getCurrentPosition();
    animatedMapMove(LatLng(location.latitude, location.longitude), 17.5);
  }

  changeMapStyle() {
    if (_isLight) {
      setState(() {
        _isLight = false;
        tileStyle = "clatumvh9008x14ktr37ooyxw";
        _backgroundColor = Colors.grey.shade900;
      });
    } else {
      setState(() {
        _isLight = true;
        tileStyle = "clb49ihmz000e15kivg9zqs1x";
        _backgroundColor = Colors.grey.shade400;
      });
    }
  } 

  void animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
      begin: _mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
      begin: _mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> animation =
      CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      extendBodyBehindAppBar: true,
      // ignore: prefer_const_constructors
      appBar: MenuBar(changeMapStyle: changeMapStyle),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.grey.shade900,
            child: FutureBuilder(
              future: _initialLocation,
              builder: ((context, snapshot) {
                Widget future;
                if (snapshot.hasData) {
                  future = FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                      keepAlive: true,
                      enableScrollWheel: false,
                      zoom: 17.5,
                      maxZoom: 18.4,
                      rotation: 0,
                      interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                      pinchZoomWinGestures: MultiFingerGesture.pinchZoom,
                      pinchMoveWinGestures: MultiFingerGesture.none,
                      onMapReady: () => updatePostMarkerList(),
                    ),
                    children: [
                
                      TileLayer(
                        overrideTilesWhenUrlChanges: false,
                        tileFadeInDuration: const Duration(milliseconds: 500),
                        urlTemplate:
                          "https://api.mapbox.com/styles/v1/kry3er/$tileStyle/tiles/512/{z}/{x}/{y}@2x?access_token={access_token}",
                        additionalOptions: {
                          "access_token": Env.mapToken,
                        },
                        backgroundColor: _backgroundColor,
                      ),

                      CurrentLocationLayer(
                        positionStream: const LocationMarkerDataStreamFactory()
                          .geolocatorPositionStream(
                            stream: Geolocator.getPositionStream(
                              locationSettings: const LocationSettings(
                                accuracy: LocationAccuracy.high,
                                distanceFilter: 5,
                          )))
                          ..listen(
                            (event) { 
                              setState(() {
                                locationSnapshot = 
                                '${event.latitude.toStringAsFixed(5)},'
                                '${event.longitude.toStringAsFixed(5)}';
                              });
                            }
                          ),
                        style: LocationMarkerStyle(
                          markerSize: const Size(15, 15),
                          accuracyCircleColor: Colors.indigo.withAlpha(35),
                          headingSectorColor: Colors.indigo,
                          headingSectorRadius: 60,
                          marker: DefaultLocationMarker(color: Colors.indigo.shade200),
                        ),
                      ),

                      MarkerLayer(
                        markers: markerList,
                        rotate: true,
                        rotateAlignment: Alignment.center,
                      ),
                
                    ],
                  );
                } else {
                  future = const Center(
                    child: SpinKitSquareCircle(
                      color: Colors.indigo,
                      size: 50,
                    ),
                  );
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 700),
                  child: future,
                );
              }),
            ),
          ),

          Positioned(
            left: -5,
            bottom: 20,
            child: MaterialButton(
              splashColor: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Hero(
                    tag: 'mapboxTag', 
                    child: _isLight ? 
                      Image.asset("assets/images/mapbox-logo-black.png", scale: 12)
                    : Image.asset("assets/images/mapbox-logo-white.png", scale: 12),
                  ),

                  const SizedBox(height: 10),

                  Hero(
                    tag: 'fluttermapTag',
                    child: _isLight ? 
                      Image.asset("assets/images/flutter-map-logo-black.png", scale: 5)
                    : Image.asset("assets/images/flutter-map-logo-white.png", scale: 5),
                  ),

                ],
              ),
              onPressed: () async {
                Navigator.push(context, PageRouteBuilder(
                  barrierDismissible: true,
                  opaque: false,
                  barrierColor: Colors.transparent.withOpacity(0.4),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child: const AttributionCard(),
                    );
                  },
                ));
              },
            ),
          ),

          Positioned(
            bottom: 20,
            child: MapScreenFab(userLocation: locationSnapshot),
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: LocationFab(function: centerOnLocation),
          ),

        ],
      ),
    );
  }
}
