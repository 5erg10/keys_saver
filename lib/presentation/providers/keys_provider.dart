import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';
import 'package:keys_saver/infrastructure/datasources/isar_datasource.dart';
import 'package:keys_saver/infrastructure/repository/isar_repository.dart';
import 'package:keys_saver/presentation/providers/passkey_provider.dart';

final keysDataProvider = StateNotifierProvider.autoDispose<KeysListNotifier, KeysState>((ref) {
  return KeysListNotifier(KeysState(), ref);
});

class KeysListNotifier extends StateNotifier<KeysState> {

  final Ref _ref;
  final dataRepository = IsarRepository(IsarDatasource());
  List<KeyValues> listKeys = [];

  KeysListNotifier(super.state, this._ref);

  void notifyChanges(List<KeyValues> list) async {
    list.sort((a, b) => a.titulo.compareTo(b.titulo));
    state = state.copyWith(keysList: list, updated: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(updated: false);
  }

  void getKeysList() async {
    final String? ncrk = await _ref.read(passKeyProvider.notifier).readSec();
    listKeys = await dataRepository.getSavedKeys(ncrk ?? '');
    notifyChanges(listKeys);
  }

  void removeFromKeyList(int keyId) async {
    await dataRepository.removeKey(keyId);
    getKeysList();
  }

  void addKeyList(KeyValues key) async {
    final String? ncrk = await _ref.read(passKeyProvider.notifier).readSec();
    await dataRepository.saveKey(key, ncrk ?? '');
    getKeysList();
  }

  void updateKeyValues(KeyValues key) async {
    final String? ncrk = await _ref.read(passKeyProvider.notifier).readSec();
    await dataRepository.updateKey(key, ncrk ?? '');
    getKeysList();
  }
}

class KeysState {

  final bool updated;
  final List<KeyValues>? keysList;

  KeysState({
    this.updated = false,
    this.keysList,
  });

  KeysState copyWith({
    bool? updated,
    List<KeyValues>? keysList,
  }) => KeysState(
    updated: updated ?? this.updated,
    keysList: keysList ?? this.keysList,
  );
}
