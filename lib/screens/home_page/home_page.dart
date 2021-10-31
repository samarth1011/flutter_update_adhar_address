import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_update_adhar_address/screens/offline_ekyc/request_otp_screen_just_opt.dart';
import 'package:flutter_update_adhar_address/screens/offline_ekyc/steps/request_otp_step.dart';
import 'package:flutter_update_adhar_address/services/firebase_auth_api/auth_service.dart';
import 'package:flutter_update_adhar_address/services/firebase_auth_api/user_credential.dart';
import 'package:flutter_update_adhar_address/services/process_received_address.dart';
import 'package:flutter_update_adhar_address/services/received_userd_data.dart';
import 'package:flutter_update_adhar_address/services/user_consent_details.dart';
import 'package:flutter_update_adhar_address/utils/ui_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'home_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = "";
  @override
  void initState() {
    super.initState();

    initDynamicLinks();
  }

  dynamic firebaseUsersData = {};
  dynamic dataFromRoute = {};
  // Retrieve Dynamic

  bool isMailSending = false;
  TextEditingController aadharNumberController = TextEditingController();
  UserConsentDetails userConsentDetailsObj = UserConsentDetails();
  // GlobalKey formkey = GlobalKey();

  Future<void> sendRequest(landLordEmail) async {
    print("sending requestr");
    showSimpleMessageSnackbar(context, 'Sending Mail...');
    var accessToken = userCredentialObj.accessToken;
    var displayName = AuthService.instance.currentUser!.displayName;

    print("acces tokrn $accessToken ");
    // Fetch Landlord Email and Mobile Number from API by his AadharNumber
    // void getLandLordEmailAndMobile(){}

    // Assume/suppose -- Remove this after implementation of above

    // Send Email

    await sendEmail(landLordEmail, accessToken, displayName);
    showSimpleMessageSnackbar(context, 'Mail Sent');
    print("Mail Sent");
  }

  Future sendEmail(landLordEmail, accessToken, displayName) async {
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
      ..subject = 'Consent to share your aadhaar address with $displayName'
      ..text =
          '$displayName has requested you your aadhaar address\nIf you wish to share your address please click on this link and download update aadhaar address app: $url.';
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
        Navigator.pushReplacementNamed(context, 'landLord_home', arguments: {
          'UIDReceived': code,
          'address-requester-userName': currentUserDisName,
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
    // final dataFromRoute = ModalRoute.of(context)!.settings.arguments as Map;
    firebaseUsersData = {
      'Name': AuthService.instance.currentUserName,
      'isConsentGiven': false,
      'isConsentRequested': false,
      'isConsentWaitingForConfirmation': false,
      'Consent Requested Date': null,
    };

    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('users')
        .doc(AuthService.instance.currentUserName)
        .get()
        .then((onValue) {
      (!onValue.exists)
          ? FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('users')
              .doc(AuthService.instance.currentUserName)
              .set(firebaseUsersData)
          : print("No data set");
      // exists : // does not exist ;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Aadhar'),
      ),
      drawer: const HomeDrawer(),
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

              return Center(
                child: ListView(
                  children: snapshot.data!.docs.map((document) {
                    dynamic documentData = document.data();
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (documentData['isConsentRequested'])
                                ? (documentData[
                                            'isConsentWaitingForConfirmation'] &&
                                        !documentData['isConsentGiven'])
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          child: ListTile(
                                              title: Text(
                                                  'Address Already requested'),
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
                                          subtitle: Text(
                                              "Date Requested: 20 oct 2021"),
                                          trailing: GlowText("Address Received",
                                              style: TextStyle(
                                                  color: Colors.green)),
                                        ),
                                      )
                                : ElevatedButton.icon(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              RequestOtpStepScreenJustOTP(),
                                        ),
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('LandLoard Email'),
                                            content: Column(
                                              children: [
                                                Text(
                                                    "Consent Link about sharing address would be sent to this mail"),
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

                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'LandLord Email',
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
                                                  );

                                                  Navigator.pop(context);
                                                },
                                                child: Text('Send Request'),
                                              ),
                                            ],
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
                            documentData['isConsentGiven'] &&
                                    documentData['offline-eKYC-base64'] != null
                                ? ElevatedButton.icon(
                                    onPressed: () async {
                                      var landLordAddress =
                                          await ProcessReceivedAddress()
                                              .getReceivedAddress(
                                                  context,
                                                  documentData[
                                                      'offline-eKYC-base64'],
                                                  documentData[
                                                      'password-foreKYC-file-given-by-landLord']);
                                      if (landLordAddress != null) {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(AuthService
                                                .instance.currentUser!.uid)
                                            .collection('users')
                                            .doc(AuthService
                                                .instance.currentUserName!)
                                            .update({
                                          'offline-eKYC-base64': null,
                                          'password-foreKYC-file-given-by-landLord':
                                              null,
                                        });
                                      }

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Expanded(
                                            child: AlertDialog(
                                              title: Text('LandLord Address'),
                                              content: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(landLordAddress
                                                      .toString()),
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

                                                    receivedUserDataObj
                                                            .receivedlandLordAddress =
                                                        landLordAddress;
                                                    Navigator.pop(context);
                                                    Navigator.pushNamed(
                                                      context,
                                                      'edit_address',
                                                    );
                                                  },
                                                  child: Text(
                                                      'Edit & Submit Address'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.logout),
                                    label: const Text("Edit Address"))
                                : const SizedBox(height: 10),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
      ),
    );
  }
}
