import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicLinks {
  Future handleDynamicKinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data!);

        // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      // 3a. handle link that has been retrieved
      _handleDeepLink(dynamicLink!);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });

  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data.link;
    if (deepLink != null) {
      var isRefer = deepLink.pathSegments.contains('refer');
      if (isRefer) {
        var code = deepLink.queryParameters['UID'];
        print(code.toString());
        if (code != null) {
         print("UID = $code");
          
        }
      }
    }

    }


    
  Future<String> createReferralLink(String referralCode) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://aadhaar.page.link',
      link: Uri.parse('https://fluttertutorial.com/refer?UID=$referralCode'),
      androidParameters: AndroidParameters(
        packageName: 'com.devscore.flutter_tutorials',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Refer A Friend',
        description: 'Refer and earn',
        imageUrl: Uri.parse(
            'https://www.insperity.com/wp-content/uploads/Referral-_Program1200x600.png'),
      ),
    );

    final ShortDynamicLink shortLink =
        await dynamicLinkParameters.buildShortLink();

    final Uri dynamicUrl = shortLink.shortUrl;
    print(dynamicUrl);
    return dynamicUrl.toString();
  }
  }




//  dynamic FirebaseUsersData = {
//           'isConsentGiven': true,
//           'isConsentRequested': true,
//           'isConsentWaitingForConfirmation': false,
//         };
//         FirebaseFirestore.instance
//             .collection('Users')
//             .doc(FirebaseAuth.instance.currentUser!.uid)
//             .collection('users')
//             .doc('${FirebaseAuth.instance.currentUser!.displayName}')
//             .set(FirebaseUsersData);
