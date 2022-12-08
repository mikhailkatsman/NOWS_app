import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../cards/post_card.dart';

class MarkerBuilder extends StatefulWidget {
  Function moveToMarker;
  LatLng markerLocation;
  String markerId;

  MarkerBuilder({
    super.key,
    required this.moveToMarker,
    required this.markerLocation,
    required this.markerId,
  });

  @override
  State<MarkerBuilder> createState() => _MarkerBuilderState();
}

class _MarkerBuilderState extends State<MarkerBuilder> {

  Future<bool>? _drawMarker;

  @override
  void initState() {
    super.initState();
    _drawMarker = drawMarker();
  }

  Future<bool> drawMarker() async {
    await Future.delayed(Duration(milliseconds: Random().nextInt(600)));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: false,
      future: _drawMarker,
      builder: ((context, snapshot) {
        return AnimatedScale(
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.bottomCenter,
          scale: snapshot.data! ? 2.0 : 0.0,
          child: IconButton(
            icon: Image.asset("assets/icons/post-icon.png"),
            iconSize: 50,
            onPressed: () {
              widget.moveToMarker(widget.markerLocation, 18.4);
              
              Timer(const Duration(milliseconds: 600), () {
                Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 150),
                  reverseTransitionDuration: const Duration(milliseconds: 150),
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.4),
                  opaque: false,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return ScaleTransition(
                      scale: animation,
                      child: PostCard(postId: widget.markerId),
                    );
                  },
                ));
              });
          
            },
          ),
        );
      }),
    );
  }
}