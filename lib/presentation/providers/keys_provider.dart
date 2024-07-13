import 'package:keys_saver/domain/models/keys_collection.dart';
import 'package:keys_saver/infrastructure/datasources/isar_datasource.dart';
import 'package:keys_saver/infrastructure/repository/isar_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keys_saver/infrastructure/services/encrypter_services.dart';

final keysDataProvider = StateNotifierProvider.autoDispose<KeysListNotifier, KeysState>((ref) {
  return KeysListNotifier(KeysState());
});

class KeysListNotifier extends StateNotifier<KeysState> {

  final dataRepository = IsarRepository(IsarDatasource());

  List<KeyValues> listKeys = [];

  KeysListNotifier(super.state);

  void notifyChanges(List<KeyValues> list) async  {

    list.sort((a, b) => a.titulo.compareTo(b.titulo));

    state = state.copyWith(
      keysList: list,
      updated: true
    );

    await Future.delayed(const Duration(milliseconds: 500));

    state = state.copyWith(
      updated: false
    );
  }

  void getKeysList() async {

    List<KeyValues> keys = await dataRepository.getSavedKeys();
    
    listKeys = keys.map( (key) {
      key.passW = EncrypterService.decrypt(key.passW);
      return key;
    }).toList();

    notifyChanges(listKeys);
  }

  void removeFromKeyList(int keyId) async {

    await dataRepository.removeKey(keyId);
    
    getKeysList();
  }

  void addKeyList(KeyValues key) async {

    dataRepository.saveKey(key);

    getKeysList();
  }

  void updateKeyValues(KeyValues key) async {

    dataRepository.updateKey(key);

    getKeysList();
    
  }
}

class KeysState {

  final bool updated;
  final List<KeyValues>? keysList;

  KeysState({
    this.updated = false,
    this.keysList
  });

  KeysState copyWith({
    bool? updated,
    List<KeyValues>? keysList
  }) => KeysState(
    updated: updated ?? this.updated,
    keysList: keysList ?? this.keysList
  );
}