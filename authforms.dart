import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthFormState();
  }
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  var _username = "";
  bool isLoginpage = false;

  startauthentication() {
    final validty = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validty) {
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  void submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLoginpage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isLoginpage)
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Incorrect Email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: "Enter Email",
                            labelStyle: GoogleFonts.roboto()),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide()),
                          labelText: "Username",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide()),
                          labelText: "Enter password",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: (ElevatedButton(
                        child: isLoginpage
                            ? Text(
                                'Login',
                                style: TextStyle(fontSize: 20),
                              )
                            : Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 20),
                              ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          return startauthentication();
                        },
                      )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginpage = !isLoginpage;
                          });
                        },
                        child: isLoginpage
                            ? Text(
                                "Create New Account",
                              )
                            : Text('Already a User?'),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
