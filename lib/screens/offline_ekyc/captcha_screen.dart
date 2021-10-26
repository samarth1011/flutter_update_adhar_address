import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/screens/offline_ekyc/steps/request_otp_step.dart';
import 'package:flutter_update_adhar_address/utils/ui_utils.dart';

class CaptchaScreen extends StatefulWidget {
  CaptchaScreen({Key? key}) : super(key: key);

  @override
  State<CaptchaScreen> createState() => _CaptchaScreenState();
}

class _CaptchaScreenState extends State<CaptchaScreen> {
  final requestOtpStepWidget = RequestOtpStep(
    onUidAndCaptchaVerified: (context, otpRequest) async {},
  );

  int currentStep = 0;

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stepper(
            onStepContinue: () async {
              await _onStepContinue(context);
            },
            currentStep: currentStep,
            steps: <Step>[
              Step(
                title: const Text('Request OTP'),
                content: requestOtpStepWidget,
              ),
              Step(
                title: const Text('Verify OTP'),
                content: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onStepContinue(BuildContext context) async {
    try {
      if (currentStep == 0) {
        await requestOtpStepWidget.onFormSubmit(context);
      }
      setState(() {
        currentStep++;
      });
    } catch (e) {
      showSimpleMessageSnackbar(context, e.toString());
    }
  }
}
