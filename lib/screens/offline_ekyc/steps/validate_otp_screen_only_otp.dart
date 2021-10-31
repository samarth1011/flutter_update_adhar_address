import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/data_models.dart/otp_request.dart';
import 'package:flutter_update_adhar_address/services/aadhar_api/aadhar_api.dart';
import 'package:flutter_update_adhar_address/services/firebase_auth_api/auth_service.dart';
import 'package:flutter_update_adhar_address/services/received_userd_data.dart';
import 'package:flutter_update_adhar_address/utils/ui_utils.dart';
import 'package:flutter_update_adhar_address/utils/util_functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

class ValidateOtpStepScreenOnlyOTP extends StatelessWidget {
  ValidateOtpStepScreenOnlyOTP(
    this.otpRequest,
  );

  final _otpFormKey = GlobalKey<FormState>();

  final _otpInputController = TextEditingController();

  final OtpRequest? otpRequest;
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Offline eKYC: Verify OTP',
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildOtpInputForm(context),
              const SizedBox(height: 8),
              _buildSubmitButton(context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    passwordController.text = '';
    return ElevatedButton(
      onPressed: () async {
        try {
          await onFormSubmit(context, passwordController.text);
          showSimpleMessageSnackbar(context, 'OTP validated');
          Navigator.pop(context);
          Navigator.pop(context);
        } catch (e) {
          showSimpleMessageSnackbar(context, e.toString());
        }
      },
      child: const Text(
        'Submit',
      ),
    );
  }

  Future<void> onFormSubmit(
      BuildContext context, passwordGivenByLandLordForeKYC) async {
    final isFormValid = _otpFormKey.currentState?.validate();
    if (isFormValid == false) {
      throw 'Please fill the form correctly.';
    }
    if (otpRequest == null) {
      throw 'Sorry, OTP request does not exists';
    }
    final otp = _otpInputController.text;
    final ekyc = await AadharApi.getOfflineEKYC(
      aadhaarUid: otpRequest!.uidNumber,
      transcationNumber: otpRequest!.transcationId,
      otp: otp,
      shareCode: '4567',
    );
  }

  Widget _buildOtpInputForm(BuildContext context) {
    return Form(
      key: _otpFormKey,
      child: Column(
        children: [
          _buildOtpInputField(context),
        ],
      ),
    );
  }

  Widget _buildOtpInputField(BuildContext context) {
    return TextFormField(
      controller: _otpInputController,
      keyboardType: TextInputType.number,
      validator: (text) {
        final uidInput = text ?? '';
        if (uidInput.isEmpty) {
          return "OTP cannot be empty";
        }
      },
      decoration: const InputDecoration(
        hintText: 'Enter OTP',
      ),
    );
  }
}
