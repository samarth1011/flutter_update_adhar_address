import 'dart:typed_data';
import 'dart:convert';

class Captcha {
  Map json;
  Captcha(this.json);

  String get captchaBase64String {
    return json['captchaBase64String'];
  }

  String get captchaTranscationId {
    return json['captchaTxnId'];
  }

  String get requestDate {
    return json['requestedDate'];
  }

  Uint8List get captchImageBytes {
    Uint8List bytes = base64Decode(captchaBase64String);
    return bytes;
  }
}
