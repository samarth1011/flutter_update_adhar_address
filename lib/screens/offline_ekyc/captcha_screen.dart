import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/data_models.dart/captcha.dart';
import 'package:flutter_update_adhar_address/services/aadhar_api/aadhar_api.dart';

class CaptchaScreen extends StatelessWidget {
  const CaptchaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Offline eKYC',
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            _loadCaptcha(),
          ],
        ),
      ),
    );
  }

  Widget _loadCaptcha() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<Captcha>(
        future: AadharApi.requestCaptch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final captcha = snapshot.data;
          if (captcha == null) {
            return const Text('unable to load captch');
          }

          return Image.memory(
            captcha.captchImageBytes,
            scale: 0.6,
          );
        },
      ),
    );
  }
}
