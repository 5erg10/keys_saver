
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class DevicePermissionsController extends GetxController {

  bool storagePermissionGranted = false;

  Future<bool> checkStoragePermission() async {

    storagePermissionGranted = await Permission.manageExternalStorage.request().isGranted;

    if (!storagePermissionGranted) {
      await Permission.manageExternalStorage.request();
      storagePermissionGranted = await Permission.manageExternalStorage.request().isGranted;
    }

    update();

    return storagePermissionGranted;
  }
}