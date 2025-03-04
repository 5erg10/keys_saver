import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class PassKeyController extends GetxController {

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? key;

  IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  Future<String?> readSec() async {
    final data = await _storage.read(
      key: 'passKey',
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    key = data;
    update();
    return data;
  }

  Future<bool> writeSec(String value) async {
    try {
      await _storage.write(
        key: 'passKey',
        value: value,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteSec() async {
    await _storage.delete(
      key: 'passKey',
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions()
    );
  }
}
