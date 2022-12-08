import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReauthenticationCard extends StatefulWidget {
  final FirebaseAuth auth;
  final Reference storageRef;
  final String uId;
  final DatabaseReference databaseRef;
  final Function refresh;

  ReauthenticationCard({
    super.key, 
    required this.auth,
    required this.storageRef,
    required this.uId,
    required this.databaseRef,
    required this.refresh,
  });

  @override
  State<ReauthenticationCard> createState() => _TextFormState();
}

class _TextFormState extends State<ReauthenticationCard> {

  String _email = '';
  String _password = '';

  bool _isDeleting = false;

  final _deleteformkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Material(
            color: Colors.indigo,
            elevation: 10,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              clipBehavior: Clip.hardEdge,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Form(
                  key: _deleteformkey,
                  child: Column(
                    children: [
                              
                      Material(
                        color: Colors.transparent,
                        child: Text('Delete Account', 
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                        )),
                      ),
                  
                      const SizedBox(height: 20),
                  
                      emailField(),
                  
                      const SizedBox(height: 20),
                  
                      passwordField(),

                      const SizedBox(height: 20),
        
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    
        FloatingActionButton.extended(
          heroTag: 'deleteTag',
          onPressed: () async {
            await deleteUserAccount(context).whenComplete(()
              => Navigator.popUntil(context, (route) => route.isFirst));
          },
          backgroundColor: Colors.red.shade400,
          icon: const Icon(Icons.delete_forever_rounded, color: Colors.white),
          label: _isDeleting ? const SpinKitSquareCircle(color: Colors.white, size: 15)
          : const Text('DELETE', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }


  emailField() {
    return TextFormField(
      cursorRadius: const Radius.circular(2),
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
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        isDense: true,
        icon: const Icon(Icons.email_rounded, color: Colors.white),
        hintText: 'example@email.com',
        hintStyle: TextStyle(color: Colors.indigo.shade200),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
  
  passwordField() {
    return TextFormField(
      cursorRadius: const Radius.circular(2),
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
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        isDense: true,
        icon: const Icon(Icons.password_rounded, color: Colors.white),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.indigo.shade200),
      ),
      style: const TextStyle(color: Colors.white),
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

  Future<void> deleteUserAccount(BuildContext context) async {
    setState(() {
      _isDeleting = true;
    });
    AuthCredential credential = EmailAuthProvider.credential(
      email: _email, 
      password: _password,
    );

    await widget.auth.currentUser!.reauthenticateWithCredential(credential);

    try {
      await widget.storageRef.child("avatars/${widget.uId}.jpg").delete();
    } catch (e) {
      print("ERROR DELETING AVATAR: ${e.toString()}");
    }
    
    try {
      await widget.storageRef.child("posts/${widget.uId}").delete();
    } on Exception catch (e) {
      print("ERROR DELETING POSTS: ${e.toString()}");
    }
    await widget.databaseRef.child("username_data/${widget.uId}").remove();
    await widget.auth.currentUser?.delete();

    await widget.refresh();
  }
}