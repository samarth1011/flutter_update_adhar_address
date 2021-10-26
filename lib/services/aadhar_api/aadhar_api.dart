import 'dart:convert';

import 'package:flutter_update_adhar_address/data_models.dart/captcha.dart';
import 'package:http/http.dart' as http;

class AadharApi {
  static const API_ENDPOINT =
      'https://stage1.uidai.gov.in/unifiedAppAuthService/api/v2';

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
}
