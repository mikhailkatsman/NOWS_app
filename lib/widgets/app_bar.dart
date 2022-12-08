import 'package:flutter/material.dart';
import 'package:nows_app/widgets/app_bar_avatar.dart';
import 'package:nows_app/widgets/mapmode_button.dart';

class MenuBar extends StatefulWidget with PreferredSizeWidget{
  Function changeMapStyle;

  MenuBar({super.key, required this.changeMapStyle});

  @override
  State<MenuBar> createState() => _MenuBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _MenuBarState extends State<MenuBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [

        Avatar(),

        const SizedBox(width: 20),
        
        MapmodeButton(changeMapStyle: widget.changeMapStyle),

        const SizedBox(width: 20),
      ],
    );
  }
}