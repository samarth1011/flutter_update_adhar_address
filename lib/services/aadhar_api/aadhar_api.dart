import 'dart:convert';

import 'package:flutter_update_adhar_address/data_models.dart/captcha.dart';
import 'package:flutter_update_adhar_address/data_models.dart/e_kyc.dart';
import 'package:flutter_update_adhar_address/data_models.dart/otp_request.dart';
import 'package:flutter_update_adhar_address/utils/util_functions.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AadharApi {
  static const API_ENDPOINT =
      'https://stage1.uidai.gov.in/unifiedAppAuthService/api/v2';

  /// Returns captcha from aadhar api for validation
  static Future<Captcha> requestCaptch(
      {int captchaLength = 3, int captchaType = 2}) async {
    const urlFormatted = API_ENDPOINT + '/get/captcha';
    final uri = Uri.parse(urlFormatted);
    final body = <String, dynamic>{
      "langCode": "en",
      "captchaLength": captchaLength.toString(),
      "captchaType": captchaType.toString(),
    };
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw Exception(
          '$urlFormatted returned with status code ${response.statusCode}');
    }
    final responseBody = response.body;
    final responseBodyDecodded = jsonDecode(responseBody);
    return Captcha(responseBodyDecodded);
  }

  /// Validates the captcha value and requests otp
  static Future<OtpRequest> validateCaptchAndRequestOtp({
    required Captcha captcha,
    required String captchValue,
    required String aadhaarUid,
  }) async {
    const urlFormatted = API_ENDPOINT + '/generate/aadhaar/otp';
    final uuid = generateUuidV4();
    final uri = Uri.parse(urlFormatted);
    final body = <String, dynamic>{
      "uidNumber": aadhaarUid,
      "captchaTxnId": captcha.captchaTranscationId,
      "captchaValue": captchValue,
      "transactionId": "MYAADHAAR:$uuid"
    };
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'x-request-id': uuid,
      'appid': 'MYAADHAAR',
      'Accept-Language': 'en_in',
    };
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw '$urlFormatted returned with status code ${response.statusCode}';
    }
    final responseBody = response.body;
    final responseBodyDecodded = jsonDecode(responseBody);
    return OtpRequest(responseBodyDecodded);
  }

  static Future<EKYC> getOfflineEKYC(
      {required String aadhaarUid,
      required String transcationNumber,
      required String otp,
      String shareCode = '4567'}) async {
    const urlFormatted =
        'https://stage1.uidai.gov.in/eAadhaarService/api/downloadOfflineEkyc';
    final uri = Uri.parse(urlFormatted);
    final body = <String, dynamic>{
      "txnNumber": transcationNumber,
      "otp": otp,
      "shareCode": shareCode,
      "uid": aadhaarUid,
    };
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    var response;
    try {
      response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: headers,
      );
    } catch (e) {
      print('ERROR while requesting $urlFormatted: $e');
    }
    if (response.statusCode != 200) {
      throw Exception(
          '$urlFormatted returned with status code ${response.statusCode}');
    }
    final responseBody = response.body;
    final responseBodyDecodded = jsonDecode(responseBody);
    final bodyStatusCode = responseBodyDecodded['status'];
    if (bodyStatusCode is num) {
      if (bodyStatusCode >= 400 && bodyStatusCode < 500) {
        throw responseBodyDecodded['errorDetails']['messageEnglish'];
      }
    }
    return EKYC(responseBodyDecodded);
  }
}
