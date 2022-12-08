import 'dart:io';

import 'package:flutter/material.dart';

import '../data_handling.dart';
import 'camera_card.dart';

class TextForm extends StatefulWidget {
  final File imageFile;
  final String userLocation;
  final String userId;

  const TextForm({
    super.key, 
    required this.imageFile, 
    required this.userLocation, 
    required this.userId
  });

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {

  ScrollController _scrollController = ScrollController();

  String userTitle = '';
  String userText = '';
  String timeStamp = DateTime.now().toIso8601String();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 16),
      child: Column(
        children: [
    
          Material(
            color: Colors.indigo,
            elevation: 10,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.indigo,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
    
                    Container(
                      height: 430,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(widget.imageFile),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                        
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: titleField(),
                    ),
                        
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: textField(),
                    ),
                        
                  ],
                ),
              ),
            ),
          ),
    
          const SizedBox(height: 16),
    
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
    
              SizedBox(
                width: 45,
                height: 45,
                child: FloatingActionButton( 
                  backgroundColor: Colors.indigo,
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Icon(Icons.cancel_rounded, color: Colors.white),
                ),
              ),
    
              FloatingActionButton.extended(
                heroTag: 'fabTag',
                onPressed: () async {
                  postNowCard(widget.imageFile, widget.userLocation, userTitle, userText, widget.userId, timeStamp);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.text_fields_outlined),
                label: const Text('POST'),
              ),
    
              SizedBox(
                width: 45,
                height: 45,
                child: FloatingActionButton( 
                  heroTag: 'locationTag',
                  backgroundColor: Colors.indigo,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.7),
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child: CameraViewport(userLocation: widget.userLocation, userId: widget.userId),
                        );
                      },
                    ), (route) => route.isFirst);
                  },
                  child: const Icon(Icons.cameraswitch_rounded, color: Colors.white),
                ),
              ),
    
            ],
          ),

          const SizedBox(height: 330),
    
        ],
      ),
    );
  }

  TextFormField titleField() {
    return TextFormField(
      cursorRadius: Radius.circular(2),
      cursorWidth: 5,
      cursorColor: Colors.white,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: 1,
      maxLength: 25,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        isDense: true,
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.indigo.shade200),
        helperStyle: TextStyle(color: Colors.indigo.shade200),
      ),
      style: TextStyle(color: Colors.white, fontSize: 23),
      validator: (text) {
        if (text!.isEmpty) {
          return 'Please input title!';
        } else {
          return null;
        }
      },
      onChanged: (title) {
        userTitle = title;
      },
      onTap: () => _scrollController.animateTo(330, 
        duration: Duration(milliseconds: 100), 
        curve: Curves.linear),
      onFieldSubmitted: (title) async
        => Future.delayed(Duration(milliseconds: 200), () 
        => _scrollController.animateTo(-330, 
        duration: Duration(milliseconds: 200), 
        curve: Curves.linear),
      ),
    );
  }

  TextFormField textField() {
    return TextFormField(
      cursorRadius: Radius.circular(2),
      cursorWidth: 5,
      cursorColor: Colors.white,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: 3,
      maxLength: 150,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        isDense: true,
        hintText: 'Describe what is happening!',
        hintStyle: TextStyle(color: Colors.indigo.shade200),
        helperStyle: TextStyle(color: Colors.indigo.shade200),
      ),
      style: TextStyle(color: Colors.white),
      validator: (text) {
        if (text!.isEmpty) {
          return 'Please describe what is happening!';
        } else {
          return null;
        }
      },
      onChanged: (text) {
        userText = text;
      },
      onTap: () => _scrollController.animateTo(330, 
        duration: Duration(milliseconds: 100), 
        curve: Curves.linear),
      onFieldSubmitted: (title) async
        => Future.delayed(Duration(milliseconds: 200), () 
        => _scrollController.animateTo(-330, 
        duration: Duration(milliseconds: 200), 
        curve: Curves.linear),
      ),
    );
  }
}