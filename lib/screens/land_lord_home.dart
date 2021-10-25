import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    dynamic firebaseUsersDataForConsentGiven = {
      'isConsentGiven': true,
      'isConsentRequested': true,
      'isConsentWaitingForConfirmation': false,
    };
    // dataFromRoute['currentUserDisName'].toString().replaceAll('-', ' ');
    FirebaseFirestore.instance
        .collection('Users')
        .doc(dataFromRoute["UIDReceived"])
        .collection('users')
        .doc(
            dataFromRoute['currentUserDisName'].toString().replaceAll('-', ' '))
        .update(firebaseUsersDataForConsentGiven);

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${dataFromRoute["UIDReceived"]}"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
              "Before Sending address lestcomplete eKYC UID received ${dataFromRoute["UIDReceived"]}, ${dataFromRoute["currentUserDisName"]}"),
          Text(dataFromRoute['currentUserDisName']
              .toString()
              .replaceAll('-', ' ')),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: () {}, child: Text("Proceed to eKYC")),
        ],
      ),
    );
  }
}
