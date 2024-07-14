import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secProvider = StateNotifierProvider.autoDispose<SecNotifier, SecState>((ref) {
  return SecNotifier(SecState());
});

class SecNotifier extends StateNotifier<SecState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  SecNotifier(super.state);

  Future<void> readSec() async {
    final data = await _storage.read(
      key: 'passKey',
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    state = state.copyWith(key: data, loading: false);
  }

  Future<void> writeSec(String value) async {
    await _storage.write(
      key: 'passKey',
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    readSec();
  }

  Future<void> deleteSec() async {
    await _storage.delete(
      key: 'passKey',
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions()
    );
    readSec();
  }
}

class SecState {
  final bool loading;
  final String key;

  SecState({this.loading = false, this.key = ''});

  SecState copyWith({bool? loading, String? key}) =>
      SecState(key: key ?? this.key, loading: loading ?? this.loading);
}
