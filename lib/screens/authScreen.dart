import 'package:basic_chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _submitAuth(
      String email, String password, String username, bool isLogin) async {
    UserCredential userCredential;
    try {
      if (isLogin) {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (e) {
      var message = "An error occured, please check your credentials";

      if (e.code != null) {
        message = e.code;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (e) {
      print(e);
    }
  }

  String userEmail = '';
  String userName = '';
  String userPassword = '';
  bool login = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Chatzy",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      !login
                          ? TextFormField(
                              controller: usernameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a Username';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                userName = value;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: 'Username',
                                  filled: true,
                                  fillColor: Colors.white),
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value.isEmpty || !value.contains("@")) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          userEmail = value;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          userPassword = value;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'password',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        child: login
                            ? Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                "Signup",
                                style: TextStyle(color: Colors.white),
                              ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            //to remove the soft keyboard on a successful registration.
                            FocusScope.of(context).unfocus();
                            //to save whats in the text form field
                            _formKey.currentState.save();
                            _submitAuth(userEmail.trim(), userPassword.trim(),
                                userName.trim(), login);
//                            Navigator.of(context)
//                                .pushNamed(ChatScreen.routeName);
                          }
                        },
                      ),
//                      SizedBox(
//                        height: 5,
//                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            login = !login;
                          });
                        },
                        child: login
                            ? Text(
                                "Signup instead",
                                style: TextStyle(color: Colors.blue),
                              )
                            : Text(
                                "Login instead",
                                style: TextStyle(color: Colors.blue),
                              ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
