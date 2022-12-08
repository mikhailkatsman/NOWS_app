import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../cards/account_card.dart';
import '../cards/login_card.dart';

class Avatar extends StatefulWidget {
  const Avatar({super.key});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final Reference storageRef = FirebaseStorage.instance.ref();
  bool _isLoggedIn = false;
  String uId = '';
  late Future<Uint8List> futureData;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void refresh() {
    getCurrentUser();
  }

  void getCurrentUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) { 
      if (user == null) {
        setState(() {
          _isLoggedIn = false;
        });
      } else {
        setState(() {
          _isLoggedIn = true;
          futureData = fetchAvatar(user.uid);
          uId = user.uid;
        });
      }
    });
  }

  Future<Uint8List> fetchAvatar(String uid) async {
    var image = await storageRef.child("avatars/$uid.jpg").getData().timeout(Duration(seconds: 30));
    return image!;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return FutureBuilder(
        future: futureData,
        builder:(context, snapshot) {
          Widget future;
          if (snapshot.hasData) {
            future = Hero(
              tag: 'avatarTag',
              child: Material(
                shape: const CircleBorder(),
                elevation: 6,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, PageRouteBuilder(
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.4),
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child: AccountCard(
                            refresh: refresh, 
                            avatarImage: snapshot.data!, 
                            uId: uId,
                          ),  
                        );
                      },
                    ));
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(shape:  BoxShape.circle),
                    child: Center(
                      child: CircleAvatar(
                        backgroundImage: MemoryImage(snapshot.data!),
                        radius: 25,
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            future = const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: SpinKitSquareCircle(size: 20, color: Colors.indigo),
            );
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: future,
          );
        },
      );  
    } else {
      return Hero(
        tag: 'loginTag',
        child: TextButton(
          child: Text(
            'Login',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            Navigator.push(context, PageRouteBuilder(
              barrierDismissible: true,
              barrierColor: Colors.black.withOpacity(0.4),
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: LoginCard(refresh: refresh),
                );
              },
            ));
          },
        ),
      ); 
    }
  }      
}