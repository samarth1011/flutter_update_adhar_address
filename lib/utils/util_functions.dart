import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

String generateUuidV4() {
  return const Uuid().v4();
}

Future<File> createFileFromBase64EncoddedString(String base64EncoddedString,
    {required String filename, required String fileExtension}) async {
  print('BASE 64: $base64EncoddedString');
  Uint8List bytes = base64Decode(base64EncoddedString);
  final docsDirectory = await getApplicationDocumentsDirectory();
  String dir = (docsDirectory).path;
  File file = File('$dir/$filename');
  await file.create();
  await file.writeAsBytes(bytes, flush: true);
  return file;
}

Future<void> launchURL(String urlString) async {
  await canLaunch(urlString)
      ? await launch(urlString)
      : throw 'Could not launch $urlString';
}
