import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/resources/colors/ui_palette.dart';
import 'package:flutter_update_adhar_address/screens/offline_ekyc/steps/request_otp_step.dart';
import 'package:flutter_update_adhar_address/services/firebase_auth_api/auth_service.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          StreamBuilder<User?>(
            stream: AuthService.instance.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                return buildUserAccountsHeader(user!);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child: Icon(Icons.error),
                );
              }
            },
          ),
          ListTile(
            title: Text(
              'Request OTP',
              style: TextStyle(
                color: UiPalette.textDarkShade(1),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RequestOtpStepScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(
                color: UiPalette.textDarkShade(1),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            onTap: () async {
              await AuthService.instance.signOut();
            },
          ),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader buildUserAccountsHeader(User user) {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: UiPalette.textLightShade(2),
      ),
      accountEmail: Text(
        user.email ?? "No Email",
        style: TextStyle(
          fontSize: 15,
          color: UiPalette.textDarkShade(1),
        ),
      ),
      accountName: Text(
        user.displayName ?? "No Name",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: UiPalette.textDarkShade(1),
        ),
      ),
      currentAccountPicture: AuthService.instance.userPhotoUrl == null
          ? null
          : CircleAvatar(
              backgroundImage: NetworkImage(
                AuthService.instance.userPhotoUrl!,
              ),
            ),
    );
  }
}
