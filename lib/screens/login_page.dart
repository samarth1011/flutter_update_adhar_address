// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  dynamic accessTokeVariable;

  dynamic FirebaseUsersData = {};

  GoogleSignIn google_sign_in =
      GoogleSignIn(scopes: ['https://mail.google.com/']);
  bool pressedGoogleSignIn = false;

  @override
  void initState() {
    super.initState();
    print("inside signup");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SignUP")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // SizedBox(height: 50),

            pressedGoogleSignIn
                ? CircularProgressIndicator()
                : SignInButton(Buttons.Google, onPressed: () async {
                    setState(() {
                      pressedGoogleSignIn = true;
                    });

                    await google_sign_in
                        .signIn()
                        .then(
                          (result) => {
                            result!.authentication.then((googleKey) {
                              accessTokeVariable = googleKey.accessToken;
                              print("-----------passing: " + result.toString());
                              FirebaseAuth.instance
                                  .signInWithCredential(
                                      GoogleAuthProvider.credential(
                                idToken: googleKey.idToken,
                                accessToken: googleKey.accessToken,
                              ))
                                  .then((signedInUser) {
                                print("Signed in as ${signedInUser}");
                                print(
                                    "-------------===============----------------");
                                print(signedInUser.user!.displayName);

                               

                                print("snapshot is null");

                                // Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                    context, 'homePage', arguments: {
                                  'accessToken': accessTokeVariable,
                                  'userName': signedInUser.user!.displayName
                                });
                              }).catchError((e) {
                                print('some error occured in ....&&&&&&& $e');
                              });
                            }).catchError((e) {
                              print('some error occured in %%%%%%% $e');
                            })
                          },
                        )
                        .catchError((e) {
                      print('some error occured in ######## $e');
                    });
                  }),
          ]),
        ),
      ),
    );
  }
}
