import 'package:flutter/material.dart';

class MapmodeButton extends StatefulWidget {
  Function changeMapStyle;

  MapmodeButton({super.key, required this.changeMapStyle});

  @override
  State<MapmodeButton> createState() => _MapmodeButtonState();
}

class _MapmodeButtonState extends State<MapmodeButton> {
  bool _isLight = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: MaterialButton(
        padding: const EdgeInsets.all(5),
        clipBehavior: Clip.antiAlias,
        splashColor: _isLight? 
          Colors.blueAccent
        : Colors.yellowAccent,
        shape: const CircleBorder(),
        color: Colors.grey.shade800,
        elevation: 6,
        onPressed: () { 
          widget.changeMapStyle();
          if (_isLight) {
            setState(() => _isLight = false);
          } else {
            setState(() => _isLight = true);
          }
        },
        child: _isLight? 
          const Icon(Icons.dark_mode_rounded, color: Colors.white)
        : const Icon(Icons.light_mode_rounded, color: Colors.white),
      ),
    );
  }
}