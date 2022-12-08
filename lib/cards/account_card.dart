import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'reauthentication_card.dart';

class AccountCard extends StatefulWidget {
  final Function refresh;
  Uint8List avatarImage;
  final String uId;

  AccountCard({
    super.key, 
    required this.refresh, 
    required this.avatarImage, 
    required this.uId
  });

  @override
  State<AccountCard> createState() => _TextFormState();
}

class _TextFormState extends State<AccountCard> {

  String _username = '';
  final _accountKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  final Reference storageRef = FirebaseStorage.instance.ref();
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(130, 100, 20, 400),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Hero(
                      tag: 'avatarTag',
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(shape:  BoxShape.circle),
                        child: Center(
                          child: CircleAvatar(
                            backgroundImage: MemoryImage(widget.avatarImage),
                            radius: 30,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Text("Logged in as:", style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                        )),

                        const SizedBox(height: 8),

                        Text(_username, style: const TextStyle(
                          fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                        )),

                      ],
                    ),

                  ],
                ),

                const SizedBox(height: 20),

                Form(
                  key: _accountKey,
                  child: changeUsername(),
                ),
              
                TextButton.icon(
                  onPressed: () async {
                    changeAvatar();
                  },
                  icon: const Icon(Icons.portrait_rounded, color: Colors.white), 
                  label: const Text('Change avatar', style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                  )),
                ),
              
                TextButton.icon(
                  onPressed: () {
                    signUserOut().whenComplete(() { 
                      widget.refresh();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    });
                  }, 
                  icon: const Icon(Icons.logout_rounded, color: Colors.white), 
                  label: const Text('Logout', style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                  )),
                ),
              
                Hero(
                  tag: 'deleteTag',
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.7),
                        opaque: false,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ReauthenticationCard(
                              auth: auth,
                              storageRef: storageRef,
                              uId: widget.uId,
                              databaseRef: databaseRef,
                              refresh: widget.refresh,
                            ),
                          );
                        },
                      ), (route) => route.isFirst);
                    },
                    icon: Icon(Icons.delete_forever_rounded, color: Colors.red.shade300),
                    label: Text('Delete Account', style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade300,
                    )),
                  ),
                ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUserOut() async {
    await auth.signOut();
  }
  
  Future<void> changeAvatar() async {
    try {
      final XFile? avatarData = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150,
        requestFullMetadata: false,
      );
      if (avatarData != null) {
        File avatarFile = File(avatarData.path);
        await storageRef.child("avatars/${auth.currentUser?.uid}.jpg").putFile(avatarFile);
        Uint8List avatarBytes = await avatarFile.readAsBytes();
        setState(() {
          widget.avatarImage = avatarBytes;
        });
        print("AVATAR PICKED!");
      }
    } on Exception catch (e) {
      print(e);
    }
  }
  
  changeUsername() {
    return TextFormField(
      cursorRadius: const Radius.circular(2),
      cursorWidth: 5,
      cursorColor: Colors.white,
      keyboardType: TextInputType.name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (username) {
        if (username!.isEmpty) {
          return 'Username can not be empty';
        }
        if (username.length > 15) {
          return 'Maximum 15 characters';
        }
      },
      onChanged: (username) {
        _username = username;
      },
      onFieldSubmitted: (username) async {
        await databaseRef.child("username_data/${widget.uId}").set({
          "username": username,
        });
        setState(() {
          _accountKey.currentState?.reset();
          _username = username; 
        });
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(Icons.electric_bolt_rounded, color: Colors.white,),
        prefixIconConstraints: BoxConstraints(minWidth: 40),
        labelText: 'Change name',
        labelStyle: TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
  
  void fetchUsername() async {
    await databaseRef.child("username_data/${widget.uId}").get().then((data) {
      setState(() {
        _username = data.child("username").value.toString(); 
      });
    });
  }
}