import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../cards/camera_card.dart';

class MapScreenFab extends StatefulWidget {
  final String userLocation;

  const MapScreenFab({super.key, required this.userLocation});

  @override
  State<MapScreenFab> createState() => _MapScreenFabState();
}

class _MapScreenFabState extends State<MapScreenFab> {

  Color _buttonStatus = Colors.grey.shade900;
  Color _textStatus = Colors.grey.shade700;
  String userId = '';
  bool _isLoggedIn = false;

  @override
  void initState() {
    checkUserStatus();
    super.initState();
    
  }

  buttonEnabled() {
    print('MAP_LOCATION: ${widget.userLocation}');
    Navigator.push(context, PageRouteBuilder(
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: CameraViewport(userLocation: widget.userLocation, userId: userId),
        );
      },
    ));
  }

  void checkUserStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          _buttonStatus = Colors.grey.shade900;
          _textStatus = Colors.grey.shade700;
          _isLoggedIn = false;
        });
      } else {
        setState(() {
          _buttonStatus = Colors.indigo;
          _textStatus = Colors.white;
          userId = user.uid;
          _isLoggedIn = true;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      key: const Key('_fabKey'),
      heroTag: 'fabTag',
      onPressed: _isLoggedIn ? () {
        buttonEnabled();
      } : null,
      icon: Icon(Icons.electric_bolt_rounded, color: _textStatus),
      label: Text('NOW', style: TextStyle(color: _textStatus)),
      backgroundColor: _buttonStatus,
    );
  }
}