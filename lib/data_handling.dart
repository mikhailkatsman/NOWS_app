import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string_generator/random_string_generator.dart';

Future<void> postNowCard(
  File imageFile, 
  String userLocation,  
  String userTitle,
  String userText, 
  String userId,
  String userTimeStamp
  ) async {

  final file = imageFile;
  final location = userLocation;
  final title = userTitle;
  final text = userText;
  final id = userId;
  final timeStamp = userTimeStamp;
  
  final filePath = "posts/$id/${title.replaceAll(' ', '_')}.jpg";

  final metadata = SettableMetadata(
    contentType: "image/jpeg",
    customMetadata: {"uid": id},
  );

  final Reference storageRef = FirebaseStorage.instance.ref();
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  final uploadTask = storageRef
      .child(filePath)
      .putFile(file, metadata);

  uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
    switch (taskSnapshot.state) {
      case TaskState.running:
        final progress =
            100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
        print("Upload is $progress% complete.");
        break;
      case TaskState.paused:
        print("Upload is paused.");
        break;
      case TaskState.canceled:
        print("Upload was canceled.");
        break;
      case TaskState.error:
        print("Upload error!");
        break;
      case TaskState.success:
        print("IMAGE UPLOAD COMPLETE!!!");
        uploadNowPost(databaseRef, storageRef, id, title, location, text, filePath, timeStamp); 
        break;
    }
  });
}

Future<void> uploadNowPost(
  DatabaseReference databaseRef,
  Reference storageRef,
  String id,
  String title,
  String location,
  String text,
  String filePath,
  String timeStamp
  ) async {

  var keyGenerator = RandomStringGenerator(
    hasSymbols: false,
    fixedLength: 20,
  );

  await downloadImageUrl(storageRef, filePath)
      .then((url) {
        String imageUrl = url;
        print('GOT IMAGE URL: $imageUrl');

        String key = keyGenerator.generate();

        databaseRef
            .child("post_data/$key")
            .set({
              "userId": id,
              "timeStamp": timeStamp,
              "imageUrl": imageUrl,
              "title": title,
              "text": text
            })
            .then((_) => print('POST DATA UPLOAD COMPLETE!!!'));
        databaseRef
            .child("location_data/$key")
            .set({
              "lat": location.substring(0, location.indexOf(',')),
              "lng": location.substring(location.indexOf(',') + 1)
            })
            .then((_) => print('POST LOCATION UPLOAD COMPLETE!!!')); 
      });
}

Future<String> downloadImageUrl(Reference storageRef, String filePath) async {
  return (await storageRef
      .child(filePath)
      .getDownloadURL()
  ).toString();
}