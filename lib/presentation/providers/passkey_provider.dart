import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PassKeyState {
  final String? key;
  const PassKeyState({this.key});
}

class PassKeyNotifier extends StateNotifier<PassKeyState> {
  PassKeyNotifier() : super(const PassKeyState());

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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
    state = PassKeyState(key: data);
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
      state = PassKeyState(key: value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteSec() async {
    await _storage.delete(
      key: 'passKey',
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    state = const PassKeyState();
  }
}

final passKeyProvider = StateNotifierProvider<PassKeyNotifier, PassKeyState>(
  (ref) => PassKeyNotifier(),
);
