// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/data_models.dart/captcha.dart';
import 'package:flutter_update_adhar_address/data_models.dart/otp_request.dart';
import 'package:flutter_update_adhar_address/screens/offline_ekyc/steps/validate_otp_step.dart';
import 'package:flutter_update_adhar_address/services/aadhar_api/aadhar_api.dart';
import 'package:flutter_update_adhar_address/utils/ui_utils.dart';

typedef OnUidCaptchaVerifiedCallback = Future<void> Function(
    BuildContext context, OtpRequest otpRequest);

class RequestOtpStepScreen extends StatelessWidget {
  RequestOtpStepScreen({
    Key? key,
  }) : super(key: key);

  final _captchFormKey = GlobalKey<FormState>();
  final _uidInputController = TextEditingController();
  final _captchaInputController = TextEditingController();

  Captcha? captcha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Offline eKYC: Request OTP',
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildUidAndCaptchaForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUidAndCaptchaForm(BuildContext context) {
    return Form(
      key: _captchFormKey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildAadharInputField(context),
          const SizedBox(height: 8),
          _loadCaptcha(context),
          const SizedBox(height: 8),
          _buildCaptchaInputField(context),
          const SizedBox(height: 8),
          _buildSubmitButton(context),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await onFormSubmit(context);
        } catch (e) {
          showSimpleMessageSnackbar(context, e.toString());
        }
      },
      child: const Text(
        'Submit',
      ),
    );
  }

  Widget _buildCaptchaInputField(BuildContext context) {
    return TextFormField(
      controller: _captchaInputController,
      keyboardType: TextInputType.text,
      validator: (text) {
        final uidInput = text ?? '';
        if (uidInput.isEmpty) {
          return "Captcha cannot be empty";
        }
      },
      decoration: const InputDecoration(
        hintText: 'Enter the captcha',
      ),
    );
  }

  Widget _buildAadharInputField(BuildContext context) {
    return TextFormField(
      controller: _uidInputController,
      keyboardType: TextInputType.number,
      validator: (text) {
        final uidInput = text ?? '';
        if (uidInput.isEmpty) {
          return "Aadhaar number cannot be empty";
        }
        if (uidInput.length != 12) {
          return "Aadhaar number should be a 12 digit number";
        }
      },
      decoration: const InputDecoration(
        hintText: 'Enter 12-digit aadhaar number',
      ),
    );
  }

  Widget _loadCaptcha(BuildContext context) {
    return FutureBuilder<Captcha>(
      future: AadharApi.requestCaptch(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        captcha = snapshot.data;
        if (captcha == null) {
          return const Text('unable to load captch');
        }

        return Image.memory(
          captcha!.captchImageBytes,
          scale: 0.6,
        );
      },
    );
  }

  Future<void> onFormSubmit(BuildContext context) async {
    final isFormValid = _captchFormKey.currentState?.validate();
    if (isFormValid == false) {
      throw 'Please fill the form correctly.';
    }
    if (captcha == null) {
      throw 'Sorry, unable to load captcha';
    }
    final aadhaarUid = _uidInputController.text;
    final captchaAns = _captchaInputController.text;
    final otpRequest = await AadharApi.validateCaptchAndRequestOtp(
        captcha: captcha!, captchValue: captchaAns, aadhaarUid: aadhaarUid);
    if (otpRequest.status == false) {
      throw otpRequest.message;
    }
    showSimpleMessageSnackbar(
        context, 'OTP sent to the given aadhaar registered phone number');
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ValidateOtpStepScreen(
          otpRequest,
        ),
      ),
    );
  }
}
