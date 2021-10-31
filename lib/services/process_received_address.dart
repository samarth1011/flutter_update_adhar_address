import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_update_adhar_address/services/received_userd_data.dart';
import 'package:flutter_update_adhar_address/utils/ui_utils.dart';
import 'package:flutter_update_adhar_address/utils/util_functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

// import 'package:xml_parser/xml_parser.dart';

class ProcessReceivedAddress {
  dynamic getReceivedAddress(
      context, eKycXMLBase64, passwordReceivedToOpenFile) async {
    //decrypt pass
    try {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String decryptedP = stringToBase64.decode(passwordReceivedToOpenFile);
      print(decryptedP);
      passwordReceivedToOpenFile = decryptedP;
    } catch (e) {
      print("Some error ocurred while decrypting");
    }

    final file = await createFileFromBase64EncoddedString(eKycXMLBase64,
        filename: 'ekyc-file', fileExtension: 'zip');
    final fileCreated = await file.exists();
    if (fileCreated) {
      final zipFile = File("${file.path}");

      try {
        dynamic landLordAddress = await unarchiveAndSaveAndDelete(
            zipFile, passwordReceivedToOpenFile);
        return landLordAddress;
      } catch (e) {
        showSimpleMessageSnackbar(
            context, 'Could not extract the zip file - $e');
      }
      showSimpleMessageSnackbar(
          context, 'eKYC file downloaded at ${file.path}');
    } else {
      showSimpleMessageSnackbar(context, 'Could not download eKYC file');
    }
  }

  dynamic unarchiveAndSaveAndDelete(
      var zippedFile, passwordReceivedToOpenFile) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder()
        .decodeBytes(bytes, verify: true, password: passwordReceivedToOpenFile);
    for (var file in archive) {
      var fileName = '/storage/emulated/0/ourApp/${file.name}';
      if (file.isFile) {
        var outFile = File(fileName);
        //print('File:: ' + outFile.path);

        // outFile = await outFile.create(recursive: true);

        await outFile.writeAsBytes(file.content);
        // final contents = await outFile.readAsString();
        final contents = XmlDocument.parse(outFile.readAsStringSync());
        print("read contents = $contents ");
        print("Hello");
        var addressXML = contents.rootElement.firstElementChild!
            .firstElementChild!.nextElementSibling;

        var receivedAddress = addressFormater(addressXML);

        if (receivedAddress != null) {
          //delete files
          try {
            final dir = Directory('/storage/emulated/0/ourApp');
            dir.deleteSync(recursive: true);
            print("directory deleted succesully");
          } catch (e) {
            print("Not able to delete directory");
          }
        }
        // print(kaiari);

        return receivedAddress;
      }
    }
  }

  dynamic addressFormater(addressXML) {
    return (addressXML.getAttribute('loc') +
        ', ' +
        addressXML.getAttribute('landmark') +
        ', ' +
        addressXML.getAttribute('po') +
        ', ' +
        addressXML.getAttribute('subdist') +
        ', ' +
        addressXML.getAttribute('dist') +
        ', ' +
        addressXML.getAttribute('state') +
        ', ' +
        addressXML.getAttribute('pc'));
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
}
