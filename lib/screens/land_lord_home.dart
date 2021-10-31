import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/screens/offline_ekyc/steps/request_otp_step.dart';
import 'package:flutter_update_adhar_address/services/firebase_auth_api/auth_service.dart';
import 'package:flutter_update_adhar_address/services/received_userd_data.dart';
import 'package:flutter_update_adhar_address/utils/ui_utils.dart';

class LandLordHomeView extends StatefulWidget {
  LandLordHomeView({Key? key}) : super(key: key);

  @override
  _LandLordHomeViewState createState() => _LandLordHomeViewState();
}

class _LandLordHomeViewState extends State<LandLordHomeView> {
  Map dataFromRoute = {'UIDReceived': 'Loading'};

  @override
  Widget build(BuildContext context) {
    final dataFromRoute = ModalRoute.of(context)!.settings.arguments as Map;

    dynamic firebaseLandlordData = {
      'Name': AuthService.instance.currentUserName,
      'isLandLord': true,
      'is-address-sent': false,
      'isConsentGiven': false,
      'isConsentRequested': false,
      'isConsentWaitingForConfirmation': false,
      'Consent Requested Date': null,
      'Address-requested-person-firbase-uid': dataFromRoute["UIDReceived"],
      'Address-requested-person-name':
          dataFromRoute['address-requester-userName'],
    };
    // dataFromRoute['currentUserDisName'].toString().replaceAll('-', ' ');
    FirebaseFirestore.instance
        .collection('Users')
        .doc(AuthService.instance.currentUser!.uid)
        .collection('users')
        .doc(AuthService.instance.currentUserName)
        .get()
        .then((onValue) {
      (!onValue.exists)
          ? FirebaseFirestore.instance
              .collection('Users')
              .doc(AuthService.instance.currentUser!.uid)
              .collection('users')
              .doc(AuthService.instance.currentUserName)
              .set(firebaseLandlordData)
          : FirebaseFirestore.instance
              .collection('Users')
              .doc(AuthService.instance.currentUser!.uid)
              .collection('users')
              .doc(AuthService.instance.currentUserName)
              .update(firebaseLandlordData);
      // exists : // does not exist ;
    });

    receivedUserDataObj.addressRequesterFirebaseUID =
        dataFromRoute["UIDReceived"];
    receivedUserDataObj.addressRequesterFirebaseUsername =
        dataFromRoute['address-requester-userName'];
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${AuthService.instance.currentUserName}"),
      ),
      body: Center(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('users')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((document) {
                  dynamic documentData = document.data();
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              '${dataFromRoute["address-requester-userName"]} has requested you your aadhaar address would you like to share your adress with him.'),
                          const SizedBox(
                            height: 30,
                          ),
                          (!documentData['is-address-sent'])
                              ? ElevatedButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Enter 4 digit password to access your address'),
                                          content: Column(
                                            children: [
                                              Text(
                                                  "This password would be only shared with ${receivedUserDataObj.addressRequesterFirebaseUsername} so that he can access your address"),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextField(
                                                  // inputFormatters: <TextInputFormatter>[
                                                  //   FilteringTextInputFormatter.alow(RegExp(
                                                  //       r'^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$')),
                                                  // ],
                                                  controller:
                                                      passwordController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Password for Accessing eKYC',
                                                      prefixIcon:
                                                          Icon(Icons.password)))
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              // : Colors.black,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('CANCEL'),
                                            ),
                                            ElevatedButton(
                                              // textColor: Colors.black,
                                              onPressed: () async {
                                                try {
                                                  encryptPasswordAndAddToDatabase(
                                                      passwordController.text);

                                                  Navigator.pop(
                                                    context,
                                                  );
                                                } catch (e) {
                                                  showSimpleMessageSnackbar(
                                                      context, e.toString());
                                                }

                                                // Navigator.pushNamed(context, 'address_sent_to_user_page');
                                              },
                                              child: Text('Send Your Address'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RequestOtpStepScreen(),
                                      ),
                                    );
                                  },
                                  child: Text("Yes Share address"))
                              : Text("Address Sent"),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}

encryptPasswordAndAddToDatabase(passwordToEncrypt) async {
  receivedUserDataObj.passwordForFile = passwordToEncrypt;
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String encryptedP = stringToBase64.encode(passwordToEncrypt);

  // dynamic cryptor = PlatformStringCryptor();
  // final salt = await cryptor.generateSalt();
  // var password = passwordToEncrypt;
  // final key = await cryptor.generateKeyFromPassword(password, salt);
  // receivedUserDataObj.passWordKey = key;
  // // here pass the password entered by user and the key
  // final encryptedP = await cryptor.encrypt(password, key);
  print(encryptedP);
  FirebaseFirestore.instance
      .collection('Users')
      .doc(receivedUserDataObj.addressRequesterFirebaseUID)
      .collection('users')
      .doc(receivedUserDataObj.addressRequesterFirebaseUsername)
      .update({'password-foreKYC-file-given-by-landLord': encryptedP});
}
