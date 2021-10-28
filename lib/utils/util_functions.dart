import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_update_adhar_address/utils/app_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

String generateUuidV4() {
  return const Uuid().v4();
}

Future<File> createFileFromBase64EncoddedString(String base64EncoddedString,
    {required String filename, required String fileExtension}) async {
  print('BASE 64: $base64EncoddedString');
  // ask for permission
  await confirmStoragePermission();

  final bytes = base64Decode(base64EncoddedString);
  final docsDirectory = await getApplicationDocumentsDirectory();
  final dir = (docsDirectory).path;
  final file = File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}

Future<void> launchURL(String urlString) async {
  await canLaunch(urlString)
      ? await launch(urlString)
      : throw 'Could not launch $urlString';
}
