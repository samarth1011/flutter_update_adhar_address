import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_update_adhar_address/services/firebase_auth_api/auth_service.dart';
import 'package:flutter_update_adhar_address/utils/ui_utils.dart';
import 'package:flutter_update_adhar_address/utils/util_functions.dart';
import 'package:flutter/material.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Users').snapshots();

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Users');

  getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print("all data = $allData");
    return allData;
  }


  getDocumentData() async {
    CollectionReference _cat = FirebaseFirestore.instance
        .collection("Users")
        .doc(AuthService.instance.currentUser!.uid)
        .collection('users');
    QuerySnapshot querySnapshot = await _cat.get();

    final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(_docData);

    // do any further processing as you want
  }

  @override
  Widget build(BuildContext context) {
    getDocumentData();
    // print(data);
    getData();

    return Scaffold(
      appBar: AppBar(
        title: Text("User Logs"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              print("data = $data");
              return ListTile(
                // title: Text(data),
                subtitle: Text(data.toString()),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
