import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_update_adhar_address/services/dynamic_links.dart';
import 'package:flutter_update_adhar_address/services/geocoding.dart';
import 'package:flutter_update_adhar_address/services/google_auth_api.dart';
import 'package:flutter_update_adhar_address/services/user_consent_details.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = "";
  @override
  void initState() {
    super.initState();

    // This method is not here take note of it....
    // print("getting coordinated....");
    // LocationHandler().compareAddress(
    //     landLordAddress: receivedAddress, userEditedAddress: userEditedAddress);

    initDynamicLinks();
  }

  dynamic FirebaseUsersData = {};
  dynamic dataFromRoute = {};
  // Retrieve Dynamic

  bool isMailSending = false;
  TextEditingController aadharNumberController = TextEditingController();
  UserConsentDetails userConsentDetailsObj = UserConsentDetails();
  // GlobalKey formkey = GlobalKey();

  Future<void> sendRequest(
      landLordAadharNumber, accessToken, displayName) async {
    print("sending requestr");
    // Fetch Landlord Email and Mobile Number from API by his AadharNumber
    // void getLandLordEmailAndMobile(){}

    // Assume/suppose -- Remove this after implementation of above
    String landLordEmail = 'samarth.mailme@gmail.com';

    // Send Email

    SendEmail(landLordEmail, accessToken, displayName);
    print("Mail Sent");
  }

  Future SendEmail(landLordEmail, accessToken, displayName) async {
    setState(() {
      isMailSending:
      true;
    });

    // Generate Dynamic Link:

    url = await buildDynamicLinks(
        FirebaseAuth.instance.currentUser!.uid, displayName);
    print("Link generated----------------$url ");

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
      ..text =
          'This is the plain text.\nThi s is link for giving consent : $url.';
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's  HTML content $url</p><br><a href="
    //     "><button>Give Consent</button></a>";

    try {
      final sendReport = await send(message, smtpServer);
      print('🥳🥳🥳🥳🥳🥳🥳Message sent: ' +
          sendReport.toString() +
          '🥳🥳🥳🥳🥳');

      dynamic dataToUpdate = {
        'isConsentRequested': true,
        'isConsentWaitingForConfirmation': true,
        'Consent Requested Date': DateTime.now(),
      };
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('users')
          .doc(displayName)
          .update(dataToUpdate);
      // print("")
      userConsentDetailsObj.isConsentRequested = true;
      userConsentDetailsObj.isConsentWaitingForConfirmation = true;
      isMailSending = false;
    } on MailerException catch (e) {
      print('&&&&&&&&&&&&&&&&&Message not sent.&&&&&&&&&');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // DONE
  }

// Address Part
// google api link - https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyBG0u_39RApawXqD5263qWbPlhFrIGGDrc
  String receivedAddress =
      "Flat no.301, 3rd Floor, CRYSTAL HEIGHTS, Datta Mandir, Opp. Mont Vert, Yamuna Nagar, Shankar Kalat Nagar, Wakad, Pune, Maharashtra 411057";
  String userEditedAddress =
      "Flat no.201, 2nd Floor, Maxima Society, Green Dr Rd, Shankar Kalat Nagar, Pimpri-Chinchwad, Maharashtra 411057";

  void submitAddress() {}
  void editAddress() {}

  // Dynamic Link stuff.
  // Dynamic Link stuff

  void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    print("initil link: $deepLink");

    if (deepLink != null) {
      print("got link");

      handleDynamicLink(deepLink);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      if (deepLink != null) {
        handleDynamicLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print("Link Error - $e");
    });
  }

  handleDynamicLink(Uri url) {
    final Uri deepLink = url;

    if (deepLink != null) {
      // Navigator.pushNamed(context, 'landLord_home',
      //     arguments: {'UIDReceived': '4525254'});
      List seperatedString = [];
      seperatedString.addAll(deepLink.path.split('/'));

      var code = seperatedString[1];

      var currentUserDisName = seperatedString[2];
      currentUserDisName = currentUserDisName.toString().replaceAll('-', ' ');

      print(code.toString());
      if (code != null) {
        print("*************UID = $code**********");
        Navigator.pushNamed(context, 'landLord_home', arguments: {
          'UIDReceived': code,
          'currentUserDisName': currentUserDisName,
        });
      }
    }
  }

  dynamic buildDynamicLinks(
      String requestedByUid, String currentUserDisName) async {
    String url = 'https://aadhaar.page.link';
    currentUserDisName = currentUserDisName.replaceAll(' ', '-');

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/$requestedByUid/$currentUserDisName'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.flutter_update_adhar_address',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Refer A Friend',
        description: 'Refer and earn',
        imageUrl: Uri.parse(
            'https://www.insperity.com/wp-content/uploads/Referral-_Program1200x600.png'),
      ),
    );
    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    print("link generated man--------");
    return dynamicUrl.shortUrl.toString();
  }

  @override
  Widget build(BuildContext context) {
    final dataFromRoute = ModalRoute.of(context)!.settings.arguments as Map;
    FirebaseUsersData = {
      'Name': dataFromRoute['userName'],
      'isConsentGiven': false,
      'isConsentRequested': false,
      'isConsentWaitingForConfirmation': false,
      'Consent Requested Date': null,
    };

    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('users')
        .doc('${dataFromRoute['userName']}')
        .get()
        .then((onValue) {
      (!onValue.exists)
          ? FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('users')
              .doc('${dataFromRoute['userName']}')
              .set(FirebaseUsersData)
          : print("No data set");
      // exists : // does not exist ;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Aadhar'),
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
              if (isMailSending) {
                return Center(
                  child:
                      CircularProgressIndicator(semanticsLabel: 'Sending Mail'),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((document) {
                  dynamic documentData = document.data();
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (documentData['isConsentRequested'])
                            ? (documentData[
                                        'isConsentWaitingForConfirmation'] &&
                                    !documentData['isConsentGiven'])
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      child: ListTile(
                                          title:
                                              Text('Address Already requested'),
                                          subtitle: Text(
                                              "Date Requested: ${documentData['Consent Requested Date']}"),
                                          trailing: GlowText(
                                              "Waiting for Confirmation",
                                              style: TextStyle(
                                                  color: Colors.orange))),
                                    ),
                                  )
                                : Card(
                                    child: ListTile(
                                      title: Text('View and edit address'),
                                      subtitle:
                                          Text("Date Requested: 20 oct 2021"),
                                      trailing: GlowText("Address Received",
                                          style:
                                              TextStyle(color: Colors.green)),
                                    ),
                                  )
                            : ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Expanded(
                                        child: AlertDialog(
                                          title:
                                              Text('LandLoard Aadhar Number'),
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
                                                controller:
                                                    aadharNumberController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'LandLord Aadhar Number',
                                                    prefixIcon:
                                                        Icon(Icons.person)),
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
                                                    dataFromRoute[
                                                        'accessToken'],
                                                    dataFromRoute['userName']);

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
                              ),
                        SizedBox(height: 30),
                        documentData['isConsentGiven']
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Expanded(
                                        child: AlertDialog(
                                          title: Text('LandLoard Address'),
                                          content: Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(receivedAddress),
                                              Divider(
                                                thickness: 2,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
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
                                                editAddress();

                                                Navigator.pop(context);
                                                Navigator.pushNamed(
                                                    context, 'edit_address');
                                              },
                                              child:
                                                  Text('Edit & Submit Address'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.logout),
                                label: Text("Edit Address"))
                            : SizedBox(height: 10),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              FirebaseAuth.instance
                                  .signOut()
                                  .then((value) => {
                                        print("Signed out"),
                                        Navigator.pushReplacementNamed(
                                            context, 'LoginPage')
                                      })
                                  .catchError((e) {
                                print(e);
                              });
                            },
                            icon: Icon(Icons.logout),
                            label: Text("Logout"))
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
