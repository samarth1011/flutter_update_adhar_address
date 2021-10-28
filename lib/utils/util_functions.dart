import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

String generateUuidV4() {
  return const Uuid().v4();
}

Future<File> createFileFromBase64EncoddedString(String base64EncoddedString,
    {required String filename, required String fileExtension}) async {
  final status = await Permission.storage.request();
  if (status.isGranted == false) {
    throw "Storage Permission not granted";
  }
  print('BASE 64: $base64EncoddedString');
  final bytes = base64Decode(base64EncoddedString);
  final docsDirectory = await getExternalStorageDirectory();
  final dir = (docsDirectory)!.path;
  final file = File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}

Future<void> launchURL(String urlString) async {
  await canLaunch(urlString)
      ? await launch(urlString)
      : throw 'Could not launch $urlString';
}
