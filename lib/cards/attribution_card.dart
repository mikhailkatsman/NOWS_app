import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AttributionCard extends StatelessWidget {
  const AttributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 470, 130, 80),
      child: Material(
        color: Colors.indigo,
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text('Powered By:', 
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                Divider(
                  thickness: 1,
                  color: Colors.white,
                ),

                Row(
                  children: [
                    const Text('©  ', 
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Hero(
                      tag: 'mapboxTag',
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          if (!await launchUrl(Uri.parse("https://www.mapbox.com/about/maps/"))) {
                            if (kDebugMode) print('Could not launch URL');
                          }
                        },
                        child: Image.asset("assets/images/mapbox-logo-white.png", scale: 7.5),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [

                    const Text('©  ', 
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Hero(
                      tag: 'fluttermapTag',
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          if (!await launchUrl(Uri.parse("https://docs.fleaflet.dev/"))) {
                              if (kDebugMode) print('Could not launch URL');
                          }
                        },
                        child: Image.asset("assets/images/flutter-map-logo-white.png", scale: 3.5),
                      ),
                    ),
                  ],
                ),

                MaterialButton(
                  padding: EdgeInsets.zero,
                  child: const Text('©  OpenStreetMap', 
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    if (!await launchUrl(Uri.parse("https://www.openstreetmap.org/about"))) {
                          if (kDebugMode) print('Could not launch URL');
                      }
                  },
                ),

                MaterialButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Improve this map', 
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (!await launchUrl(Uri.parse("https://www.mapbox.com/contribute/"))) {
                          if (kDebugMode) print('Could not launch URL');
                      }
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}