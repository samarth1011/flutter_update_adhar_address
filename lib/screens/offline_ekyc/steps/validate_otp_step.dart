import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_update_adhar_address/data_models.dart/otp_request.dart';
import 'package:flutter_update_adhar_address/services/aadhar_api/aadhar_api.dart';
import 'package:flutter_update_adhar_address/utils/ui_utils.dart';
import 'package:flutter_update_adhar_address/utils/util_functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ValidateOtpStepScreen extends StatelessWidget {
  ValidateOtpStepScreen({Key? key, this.otpRequest}) : super(key: key);

  final _otpFormKey = GlobalKey<FormState>();

  final _otpInputController = TextEditingController();

  final OtpRequest? otpRequest;

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

  Future<void> onFormSubmit(BuildContext context) async {
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
    );
    // convert the ekyc to downloadable file
    final file = await createFileFromBase64EncoddedString(ekyc.eKycXMLBase64,
        filename: ekyc.filename, fileExtension: 'zip');
    showSimpleMessageSnackbar(context, 'eKYC file downloaded at ${file.path}');
    downloadFile();
    saveFile();
  }

  downloadFile() async {}

  Future<bool> saveFile() async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory())!;
          print(directory.path);
        } else {
          return false;
        }
      } else {}
    } catch (e) {}
    return false;
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
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
