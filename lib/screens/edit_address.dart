import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/services/geocoding.dart';

class EditAddress extends StatefulWidget {
  EditAddress({Key? key}) : super(key: key);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  TextEditingController receivedAddressController = TextEditingController();
  String receivedAddress =
      "Flat no.301, 3rd Floor, CRYSTAL HEIGHTS, Datta Mandir, Opp. Mont Vert, Yamuna Nagar, Shankar Kalat Nagar, Wakad, Pune, Maharashtra 411057";

  @override
  void initState() {
    super.initState();

    receivedAddressController.text =
        "Flat no.301, 3rd Floor, CRYSTAL HEIGHTS, Datta Mandir, Opp. Mont Vert, Yamuna Nagar, Shankar Kalat Nagar, Wakad, Pune, Maharashtra 411057";
  }

  bool addressMatched = true;
  bool validatingAddress = false;

  validateAddress(addressMatched) {
    setState(() async {
      validatingAddress = true;
      addressMatched = await LocationHandler().compareAddress(
          landLordAddress: receivedAddress,
          userEditedAddress: receivedAddressController.text);
      validatingAddress = false;
      print(addressMatched);
    });
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
                    addressMatched = false;
                  });
                },
                controller: receivedAddressController,
              ),
              SizedBox(height: 20),
              !validatingAddress
                  ? ElevatedButton.icon(
                      onPressed: () {
                        validateAddress(addressMatched);
                      },
                      icon: Icon(Icons.account_box_sharp),
                      label: Text('Validate Edited Address'))
                  : CircularProgressIndicator(semanticsLabel: 'Validating..'),
              SizedBox(height: 20),
              (addressMatched)
                  ? ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.add_task),
                      label: Text('Submit Address'))
                  : Text("Please Validate address before submitting",
                      style: TextStyle(
                          color: Colors.red,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              addressMatched
                  ? Text("Address Matched",
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 16))
                  : Text("Address Not Matched",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 16))
            ],
          ),
        ));
  }
}
