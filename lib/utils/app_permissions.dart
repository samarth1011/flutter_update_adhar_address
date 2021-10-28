import 'package:permission_handler/permission_handler.dart';

Future<void> confirmStoragePermission() async {
  // ask for permission
  final status = await Permission.storage.request();
  if (status.isGranted == false) {
    throw "Please grant storage permissions";
  }
}
