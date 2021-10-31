import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/services/firebase_auth_api/auth_service.dart';
import 'package:flutter_update_adhar_address/services/geocoding.dart';
import 'package:flutter_update_adhar_address/services/received_userd_data.dart';
import 'package:flutter_update_adhar_address/utils/ui_utils.dart';

class EditAddress extends StatefulWidget {
  EditAddress({Key? key}) : super(key: key);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  TextEditingController receivedAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    receivedAddressController.text =
        receivedUserDataObj.receivedlandLordAddress!;
  }

  bool addressMatchedUI = true;
  dynamic addressMatched = true;
  bool validatingAddress = false;

  validateAddress() async {
    print("in validate address");

    print("Hello in set state");
    validatingAddress = true;
    addressMatched = await LocationHandler().compareAddress(
        landLordAddress: receivedUserDataObj.receivedlandLordAddress,
        userEditedAddress: receivedAddressController.text);
    validatingAddress = false;
    print(addressMatched);

    if (addressMatched) {
      setState(() {
        addressMatchedUI = true;
      });

      return true;
    } else {
      addressMatchedUI = false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Update Address")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    addressMatchedUI = false;
                  });
                },
                controller: receivedAddressController,
              ),
              SizedBox(height: 20),
              !validatingAddress
                  ? ElevatedButton.icon(
                      onPressed: () {
                        print("helllo   $addressMatched");
                        validateAddress();
                      },
                      icon: Icon(Icons.account_box_sharp),
                      label: Text('Validate Edited Address'))
                  : CircularProgressIndicator(),
              SizedBox(height: 20),
              (addressMatchedUI)
                  ? ElevatedButton.icon(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(AuthService.instance.currentUser!.uid)
                            .collection('users')
                            .doc(AuthService.instance.currentUserName!)
                            .update({
                              'user-edited-submitted-address':
                                  receivedAddressController.text,
                              'isConsentGiven': false,
                              'isConsentRequested': false,
                              'isConsentWaitingForConfirmation': false,
                              'last-consent-requested-date': DateTime.now(),
                              
                            })
                            .then((value) => showSimpleMessageSnackbar(
                                context, 'Address Updated Successfully!'))
                            .catchError((e) {
                              showSimpleMessageSnackbar(context,
                                  'Some error occured in submitting address - $e');
                            });
                      },
                      icon: Icon(Icons.add_task),
                      label: Text('Submit Address'))
                  : Text("Please Validate address before submitting",
                      style: TextStyle(
                          color: Colors.red,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              addressMatchedUI
                  ? Text("Address Matched",
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 16))
                  : Text(
                      "Address should be of same location as received address, Some modification to address are acceptable",
                      style: TextStyle(letterSpacing: 2, fontSize: 16))
            ],
          ),
        ));
  }
}
