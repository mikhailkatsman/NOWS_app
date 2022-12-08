import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'register_card.dart';

class LoginCard extends StatefulWidget {
  Function refresh;

  LoginCard({super.key, required this.refresh});

  @override
  State<LoginCard> createState() => _TextFormState();
}

class _TextFormState extends State<LoginCard> {

  String _email = '';
  String _password = '';

  final _loginformkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Material(
            elevation: 10,
            color: Colors.indigo,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              clipBehavior: Clip.hardEdge,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Form(
                  key: _loginformkey,
                  child: Column(
                    children: [
                              
                      const Hero(
                        tag: 'loginTag',
                        child: Material(
                          color: Colors.transparent,
                          child: Text('Login', 
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                          )),
                        ),
                      ),
                  
                      const SizedBox(height: 20),
                  
                      emailField(),
                  
                      const SizedBox(height: 20),
                  
                      passwordField(),
                
                      const SizedBox(height: 20),
                              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                
                          Text("Or", style: TextStyle(
                            fontSize: 16,
                             color: Colors.indigo.shade200,
                          )),
                
                          Hero(
                            tag: 'registerTag',
                            child: TextButton(
                              child: const Text('register here!', style: TextStyle(
                                decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: Colors.white,
                              )),
                              onPressed: () {
                                Navigator.push(context, PageRouteBuilder(
                                  maintainState: true,
                                  barrierDismissible: true,
                                  opaque: false,
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: RegisterCard(refresh: widget.refresh),
                                    );
                                  },
                                ));
                              },
                            ),
                          ),
                
                        ],
                      ),
                              
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    
        FloatingActionButton.extended(
          heroTag: 'fabTag',
          onPressed: () {
            loginUser().whenComplete(() {
              widget.refresh();
              Navigator.popUntil(context, (route) => route.isFirst);
            });
            
          },
          icon: const Icon(Icons.login_rounded),
          label: const Text('LOGIN'),
        ),
      ],
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
  
  Future<void> loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email, 
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('USER ERROR SIGNING IN: ${e.toString()}');
    }
  }
}