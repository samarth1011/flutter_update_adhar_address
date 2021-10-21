import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_update_adhar_address/services/google_auth_api.dart';
import 'package:flutter_update_adhar_address/services/user_consent_details.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMailSending = false;
  TextEditingController aadharNumberController = TextEditingController();
  UserConsentDetails userConsentDetailsObj = UserConsentDetails();
  // GlobalKey formkey = GlobalKey();

  Future<void> sendRequest(landLordAadharNumber, accessToken) async {
    // Fetch Landlord Email and Mobile Number from API by his AadharNumber
    // void getLandLordEmailAndMobile(){}

    // Assume/suppose -- Remove this after implementation of above
    String landLordEmail = 'samarth.mailme@gmail.com';

    // Send Email

    SendEmail(landLordEmail, accessToken);
    print("Mail Sent");
  }

  Future SendEmail(landLordEmail, accessToken) async {
    setState(() {
      isMailSending:
      true;
    });
    // final user = await GoogleAuthApi.signIn();

    // if (user == null) return;

    String token = accessToken;
    print("^^^^^^token = $token^*****");
    final smtpServer = gmailSaslXoauth2(landLordEmail, token);
    // Create our message.
    final message = Message()
      ..from = Address('samarth.mailme@gmail.com', 'Samarth godase')
      ..recipients.add(landLordEmail)
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThi s is line 2 of the text part.';
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('🥳🥳🥳🥳🥳🥳🥳Message sent: ' +
          sendReport.toString() +
          '🥳🥳🥳🥳🥳');
      setState(() {
        userConsentDetailsObj.isConsentRequested = true;
        userConsentDetailsObj.isConsentWaitingForConfirmation = true;
        isMailSending = false;
      });
    } on MailerException catch (e) {
      print('&&&&&&&&&&&&&&&&&Message not sent.&&&&&&&&&');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // DONE
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final snackBar = SnackBar(content: Text('Welcome ${data['userName']}'));
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    _HomePageState() {
      scheduleMicrotask(
          () => _scaffoldKey.currentState!.showSnackBar(snackBar));
    }

    () {
      scheduleMicrotask(
          () => _scaffoldKey.currentState!.showSnackBar(snackBar));
    };

    @override
    void initState() {
      Future<Null>.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      super.initState();
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Update Aadhar'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ((isMailSending)
                  ? CircularProgressIndicator(semanticsLabel: 'Sending Mail')
                  : ((userConsentDetailsObj.isConsentRequested &&
                          !isMailSending)
                      ? (userConsentDetailsObj.isConsentWaitingForConfirmation)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                    title: Text('Address Already requested'),
                                    subtitle:
                                        Text("Date Requested: 20 oct 2021"),
                                    trailing: GlowText(
                                        "Waiting for Confirmation",
                                        style:
                                            TextStyle(color: Colors.orange))),
                              ),
                            )
                          : ListTile(
                              title: Text('View and edit address'),
                              subtitle: Text("Date Requested: 20 oct 2021"),
                              trailing: GlowText("Address Received",
                                  style: TextStyle(color: Colors.green)),
                            )
                      : ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Expanded(
                                  child: AlertDialog(
                                    title: Text('LandLoard Aadhar Number'),
                                    content: Column(
                                      children: [
                                        Text(
                                            "---------------------Some Info Here------------------"),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          // inputFormatters: <TextInputFormatter>[
                                          //   FilteringTextInputFormatter.allow(RegExp(
                                          //       r'^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$')),
                                          // ],
                                          controller: aadharNumberController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText:
                                                  'LandLord Aadhar Number',
                                              prefixIcon: Icon(Icons.person)),
                                        )
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
                                        onPressed: () {
                                          sendRequest(
                                              aadharNumberController.text,
                                              data['accessToken']);

                                          Navigator.pop(context);
                                        },
                                        child: Text('Send Request'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.update),
                          label: !isMailSending
                              ? Text('Request Landlord Address')
                              : Text('Sending Mail....'),
                        )))
            ],
          ),
        ));
  }
}


// class AadhaarForm extends StatelessWidget {
//   const AadhaarForm({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [],
//     );
//   }
// }
