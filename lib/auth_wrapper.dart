import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/screens/home_page/home_page.dart';
import 'package:flutter_update_adhar_address/screens/login_page.dart';

import 'resources/values/dimens.dart';
import 'services/firebase_auth_api/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // initialize Sizes singleton
    Dimens.instance.init(context);
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return const LoginPage();
        } else {
          return const HomePage();
        }
      },
    );
  }
}
