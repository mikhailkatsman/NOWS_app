import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nows_app/widgets/attend_fab.dart';

import '../screens/image_screen.dart';

class PostCard extends StatefulWidget {
  final String postId;

  const PostCard({super.key, required this.postId});

  @override
  State<PostCard> createState() => _TextFormState();
}

class _TextFormState extends State<PostCard> {

  late Future<List<Object>> futureData;
  late DateTime timeNow;

  final Reference storageRef = FirebaseStorage.instance.ref();
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    futureData = fetchData(widget.postId);
    timeNow = DateTime.now();
  }

  Future<List<Object>> fetchData(postId) async {
    var snapshot = await databaseRef.child("post_data/$postId").get();
    
    if (snapshot.exists) {
      var usernameData = await databaseRef
          .child("username_data/${snapshot.child("userId").value.toString()}")
          .get();
      if (usernameData.exists) {
        List<Object> dataList = [
          DateTime.parse(snapshot.child("timeStamp").value.toString()),
          snapshot.child("title").value.toString(),
          snapshot.child("text").value.toString(),
          fetchImage(snapshot.child("imageUrl").value.toString()),
          await fetchAvatar(snapshot.child("userId").value.toString()),
          usernameData.child("username").value.toString()
        ];

        print("FETCHED DATA!!!");
        return dataList;
      } else {
        throw const FormatException();
      }
    } else {
      throw const FormatException();
    }
  }
  
  Future<Uint8List> fetchAvatar(userId) async {
    var snapshot = await storageRef.child("avatars/$userId.jpg").getData();
      if (snapshot!.isNotEmpty) {
        return snapshot;
      } else {
        ByteData byteData = await DefaultAssetBundle.of(context)
                        .load("assets/icons/avatar-icon.png");
        return byteData.buffer.asUint8List();
      }
  }

  FadeInImage fetchImage(url) {
    return FadeInImage.assetNetwork(
      fadeInDuration: const Duration(milliseconds: 300),
      placeholder: "assets/images/placeholder_image.png",
      image: url as String,
      fit: BoxFit.cover,
    );
  }

  String getTime(postTime) {
    var differenceSec = (timeNow.difference(postTime)).inSeconds;
    var differenceMin = (timeNow.difference(postTime)).inMinutes;
    var differenceHour = (timeNow.difference(postTime)).inHours;
    if (differenceSec < 60) {
      return "less than a minute ago";
    } else if (differenceMin > 60 && differenceMin < 120) {
      return "$differenceHour hour ${differenceMin - 60} minutes ago";
    } else if (differenceMin >= 120) {
      return "2 or more hours ago";
    } else {
      return "$differenceMin minutes ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 90),
      child: Material(
        color: Colors.black,
        elevation: 10,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.indigo.shade700,
            borderRadius: const BorderRadius.all(Radius.circular(30))),
          clipBehavior: Clip.antiAlias,
          child: FutureBuilder(
            future: futureData,
            builder: ((context, snapshot) {
              Widget future;
              if (snapshot.hasData) {
                future = Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    
                    InkWell(
                      onTap: () {
                        Navigator.push(context, PageRouteBuilder(
                          maintainState: true,
                          fullscreenDialog: true,
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ImageScreen(image: snapshot.data![3] as FadeInImage),
                            );
                          },
                        ));
                      },
                      splashColor: Colors.indigo,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: snapshot.data![3] as FadeInImage,
                      ),
                    ),
                        
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 380, 15, 15),
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                                
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(shape: BoxShape.circle),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: MemoryImage(snapshot.data![4] as Uint8List),
                                      radius: 25,
                                    ),
                                  ),
                                                
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 5, 20, 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                    
                                        Row(
                                          children: [
                
                                            Text(
                                              "by ", 
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.indigo.shade100, 
                                              ),
                                            ),
                
                                            Text(
                                              snapshot.data![5] as String, 
                                              style: TextStyle(
                                                fontSize: 20, 
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                
                                          ],
                                        ),
                                        
                                        Text(
                                          "Posted ${getTime(snapshot.data![0])}", 
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.indigo.shade100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                                
                                ],
                              ),
                            ),
                            
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                
                            Expanded(
                              flex: 1,
                              child: Text(
                                snapshot.data![1] as String,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                              )),
                            ),
                
                            SizedBox(height: 10),
                                
                            Expanded(
                              flex: 2,
                              child: Text(snapshot.data![2] as String, 
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                              )),
                            ),
                
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text("People attending:  ",
                                      style: TextStyle(
                                        color: Colors.indigo.shade100,
                                      )),
                                      Text("20",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ],
                                  ),
                
                                  SizedBox(width: 10),
                
                                  AttendFab(),
                
                                ],
                              ),
                            ),
                                
                          ],
                        ),
                      ),
                    ),
                        
                  ],
                );
              } else {
                future = const SpinKitSquareCircle(
                  color: Colors.white,
                  size: 50,
                );
              }
          
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: future,
              );
            }), 
          ),
        ),
      ),
    );
  }
}



          