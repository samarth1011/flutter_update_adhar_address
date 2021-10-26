class EKYC {
  final Map json;

  EKYC(this.json);

  String get eKycXMLBase64 {
    return json['eKycXML'];
  }

  String get filename {
    return json['fileName'];
  }

  bool get status {
    return json['status'].toString().toLowerCase() == 'success';
  }

  String get requestDate {
    return json['requestDate'];
  }

  String get uidNumber {
    return json['uidNumber'];
  }
}

/*
{
 "eKycXML": "xxxxx"
 "fileName": "offlineaadhaar20211020112556964.zip",
 "status": "Success",
 "requestDate": "2021-10-20",
 "uidNumber": "xxxxxxxx9999 "
}

*/