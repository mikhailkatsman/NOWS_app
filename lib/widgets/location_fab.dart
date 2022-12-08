import 'package:flutter/material.dart';

class LocationFab extends StatefulWidget {
  Function function;

  LocationFab({super.key, required this.function});

  @override
  State<LocationFab> createState() => _MapScreenFabState();
}

class _MapScreenFabState extends State<LocationFab> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: FloatingActionButton( 
        heroTag: 'locationTag',
        backgroundColor: Colors.grey.shade700,
        onPressed: () async {
          await widget.function();
        },
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}