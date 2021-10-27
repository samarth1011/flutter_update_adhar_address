import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_update_adhar_address/resources/colors/ui_palette.dart';
import 'package:flutter_update_adhar_address/resources/values/dimens.dart';
import 'package:flutter_update_adhar_address/services/firebase_auth_api/auth_service.dart';
import 'package:flutter_update_adhar_address/utils/util_functions.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              //height: MediaQuery.of(context).size.height * 0.36,
              width: MediaQuery.of(context).size.width * 0.75,
              child: _buildConnectOnSlackCard(),
            ),
            const Spacer(),
            Center(
              child: _buildGoogleSignInButton(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectOnSlackCard() {
    return Card(
      color: UiPalette.primaryColor,
      elevation: Dimens.defaultCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Dimens.boxCornerRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'UIDAI Hackathon'.toUpperCase(),
                  style: TextStyle(
                    color: UiPalette.textLightShade(0),
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Come and participate in the Hackathon 2021. Stand yourself a chance to become part of the Digital Journey of India.',
                  style: TextStyle(
                    color: UiPalette.textLightShade(0),
                    fontSize: 21,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildLearnMoreButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLearnMoreButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onJoinUsButtonClicked,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            UiPalette.scaffoldBgColor,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.buttonCornerRadius),
            ),
          ),
          elevation: MaterialStateProperty.all(Dimens.defaultButtonElevation),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 8,
          ),
          child: Text(
            'Learn more',
            style: TextStyle(
              color: UiPalette.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> _onJoinUsButtonClicked() async {
    await launchURL('https://hackathon.uidai.gov.in/');
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return SignInButton(
      Buttons.Google,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Dimens.buttonCornerRadius,
        ),
        side: BorderSide(
          color: UiPalette.textLightShade(2),
          width: 1,
        ),
      ),
      //text: 'Login with Google',
      elevation: Dimens.defaultButtonElevation,
      padding: const EdgeInsets.all(4),
      onPressed: () async {
        await _googleLoginButtonCallback(context);
      },
    );
  }

  Future<void> _googleLoginButtonCallback(BuildContext context) async {
    /*  await _showEmailNotInSlackTeamDialog(context, 'rahul@tenfins.com');
    return; */
    try {
      // allow user to select the google account
      final googleAccountSelected =
          await AuthService.instance.promptSelectGoogleAccount();
      if (googleAccountSelected == null) {
        print('No google account selected...');
        return;
      }

      final googleLoginTask =
          AuthService.instance.signInWithGoogle(googleAccountSelected);
      final credentials = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return FutureProgressDialog(
            googleLoginTask,
            message: const Text(
              "Please wait, logging in",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          );
        },
      );
      print("User logged in: ${credentials.user}");
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }
}
