class OtpRequest {
  final Map json;
  OtpRequest(this.json);

  String get uidNumber {
    return json['uidNumber'].toString();
  }

  String get mobileNumber {
    return json['mobileNumber'];
  }

  String get transcationId {
    return json['txnId'];
  }

  bool get status {
    return json['status'].toString().toLowerCase() == 'success';
  }

  String get message {
    return json['message'];
  }
}

/* 
{
 "uidNumber": xxxxxxxx9999,
 “mobileNumber”: 0,
 “txnId”: “mAadhaar:fb227e0b-7fdf-4555-85f1-e8ed73df2650”,
 “status”: “Success”,
 “message”: “OTP generation done successfully”
} 
*/
