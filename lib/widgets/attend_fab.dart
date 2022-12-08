import 'package:flutter/material.dart';

class AttendFab extends StatefulWidget {
  const AttendFab({super.key});

  @override
  State<AttendFab> createState() => _MapScreenFabState();
}

class _MapScreenFabState extends State<AttendFab> {

  bool _isComing = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: FloatingActionButton( 
        backgroundColor: _isComing ? Colors.red.shade900
          : Colors.indigo.shade100,
        onPressed: () async {
          setState(() {
            if(_isComing) {
              _isComing = false;
            } else {
              _isComing = true;
            }
          });
        },
        child: _isComing ? const Icon(
          Icons.directions_run_rounded,
          size: 30,
          color: Colors.white,
        )
        : const Icon(
          Icons.directions_walk_rounded,
          size: 30,
          color: Colors.indigo,
        ),
      ),
    );
  }
}