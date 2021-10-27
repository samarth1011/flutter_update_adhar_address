import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/auth_wrapper.dart';
import 'package:flutter_update_adhar_address/resources/themes/ui_themes.dart';
import 'package:flutter_update_adhar_address/screens/offline_ekyc/steps/request_otp_step.dart';

import 'screens/edit_address.dart';
import 'screens/home_page/home_page.dart';
import 'screens/land_lord_home.dart';
import 'screens/login_page.dart';

class AadhaarAddressUpdateApp extends StatelessWidget {
  const AadhaarAddressUpdateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aadhaar Address Update App',
      debugShowCheckedModeBanner: false,
      theme: Themes.primaryLightTheme,
      home: const AuthWrapper(),
      routes: {
        'homePage': (context) => HomePage(),
        'LoginPage': (context) => const LoginPage(),
        'landLord_home': (context) => LandLordHomeView(),
        'edit_address': (context) => EditAddress(),
      },
    );
  }
}
