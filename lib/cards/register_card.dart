import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class RegisterCard extends StatefulWidget {
  final Function refresh;

  RegisterCard({super.key, required this.refresh});

  @override
  State<RegisterCard> createState() => _TextFormState();
}

class _TextFormState extends State<RegisterCard> {

  final Reference storageRef = FirebaseStorage.instance.ref();
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  final ImagePicker _picker = ImagePicker();

  bool _isAuth = false;
  bool _gotAvatar = false;
  String _username = '';
  String _email = '';
  String _password = '';
  late File avatarFile;

  final _registrationformkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Material(
            color: Colors.indigo,
            elevation: 10,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              clipBehavior: Clip.hardEdge,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
                child: Form(
                  key: _registrationformkey,
                  child: Column(
                    children: [
                
                      const Hero(
                      tag: 'registerTag',
                      child: Material(
                        color: Colors.transparent,
                        child: Text('Registration', 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
          
                      const SizedBox(height: 20),
          
                      pickAvatar(),
          
                      const SizedBox(height: 10),
                
                
                      usernameField(),
                
                      const SizedBox(height: 10),
                
                      emailField(),
                
                      const SizedBox(height: 10),
                
                      passwordField(),
                
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    
        FloatingActionButton.extended(
          heroTag: 'fabTag',
          onPressed: () async {
            await createUser().whenComplete(() 
              => Navigator.popUntil(context, (route) => route.isFirst));
          },
          icon: const Icon(Icons.app_registration_rounded, color: Colors.white),
          label: _isAuth ? const SpinKitSquareCircle(color: Colors.white, size: 15)
          : const Text('REGISTER',style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
  
  Future<void> createUser() async {
    setState(() {
      _isAuth = true;
    });
    print("CREATING NEW USER: $_email, $_password, $_username");
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email, 
        password: _password,
      ).then((value) {
        databaseRef
            .child("username_data/${value.user!.uid}")
            .set({
              "username": _username,
            });
        storageRef.child("avatars/${value.user!.uid}.jpg").putFile(avatarFile)
            .whenComplete(() => widget.refresh());
      });

    } on FirebaseAuthException catch (e) {
      print('AUTH EXCEPTION: ${e.toString()}');
    }
  }

  usernameField() {
    return TextFormField(
      cursorRadius: Radius.circular(2),
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
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        isDense: true,
        icon: Icon(Icons.electric_bolt_rounded, color: Colors.white,),
        hintText: 'Username',
        hintStyle: TextStyle(color: Colors.indigo.shade200),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
  
  emailField() {
    return TextFormField(
      cursorRadius: Radius.circular(2),
      cursorWidth: 5,
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (email) {
        if(!EmailValidator.validate(email!)) {
          return 'Invalid email address';
        }
      },
      onChanged: (email) {
        _email = email;
      },
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        isDense: true,
        icon: Icon(Icons.email_rounded, color: Colors.white),
        hintText: 'example@email.com',
        hintStyle: TextStyle(color: Colors.indigo.shade200),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
  
  passwordField() {
    return TextFormField(
      cursorRadius: Radius.circular(2),
      cursorWidth: 5,
      cursorColor: Colors.white,
      obscureText: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (password) {
        if (!isPasswordCompliant(password!)) {
          return 'Invalid password';
        }
      },
      onChanged: (password) {
        _password = password;
      },
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        isDense: true,
        icon: Icon(Icons.password_rounded, color: Colors.white),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.indigo.shade200),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  bool isPasswordCompliant(String password, [int minLength = 6]) {
    if (password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasMinLength = password.length >= minLength;

    return hasDigits & hasUppercase & hasLowercase & hasMinLength;
  }
  
  pickAvatar() {
    if (_gotAvatar) {
      return SizedBox(
        height: 80,
        width: 80,
        child:ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            shape: CircleBorder(),
            backgroundColor: Colors.indigo.shade400,
          ),
          onPressed: () async {
            final XFile? avatarData = await _picker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 50,
              maxWidth: 150,
              requestFullMetadata: false,
            );
            setState(() {
              avatarFile = File(avatarData!.path);
              _gotAvatar = true;
            });
            print("AVATAR PICKED!");
          },
          child: CircleAvatar(
            backgroundImage: FileImage(avatarFile),
            radius: 80,
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 80,
        width: 80,
        child:ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: Colors.indigo.shade400,
          ),
          onPressed: () async {
            try {
              final XFile? avatarData = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 50,
                maxWidth: 150,
                requestFullMetadata: false,
              );
              if (avatarData != null) {
                setState(() {
                  avatarFile = File(avatarData.path);
                  _gotAvatar = true;
                });
                print("AVATAR PICKED!");
              }
            } on Exception catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.add_a_photo_rounded, size: 35, color: Colors.white),
        ),
      );
    }
  }
}