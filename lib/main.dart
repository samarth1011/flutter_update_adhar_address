import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/data_models.dart/otp_request.dart';
import 'package:flutter_update_adhar_address/screens/edit_address.dart';
import 'package:flutter_update_adhar_address/screens/home_page.dart';
import 'package:flutter_update_adhar_address/screens/land_lord_home.dart';
import 'package:flutter_update_adhar_address/screens/login_page.dart';
import 'package:flutter_update_adhar_address/screens/offline_ekyc/steps/request_otp_step.dart';
import 'package:flutter_update_adhar_address/screens/offline_ekyc/steps/validate_otp_step.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RequestOtpStepScreen(),
      routes: {
        'homePage': (context) => HomePage(),
        'LoginPage': (context) => SignupPage(),
        'landLord_home': (context) => LandLordHomeView(),
        'edit_address': (context) => EditAddress(),
      },
    );
  }
}
