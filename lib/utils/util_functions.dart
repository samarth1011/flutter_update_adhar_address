import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

String generateUuidV4() {
  return const Uuid().v4();
}

Future<File> createFileFromBase64EncoddedString(String base64EncoddedString,
    {required String filename, required String fileExtension}) async {
  Uint8List bytes = base64Decode(base64EncoddedString);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = File('$dir/${filename}_' +
      DateTime.now().millisecondsSinceEpoch.toString() +
      ".$fileExtension");
  await file.writeAsBytes(bytes);
  return file;
}
