
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final devicePermissionsProvider = StateNotifierProvider.autoDispose<PermissionsNotifier, PermissionState>((ref) {
  return PermissionsNotifier(PermissionState());
});

class PermissionsNotifier extends StateNotifier<PermissionState> {

  PermissionsNotifier(super.state);
  
  void requestStoragePermissions() async {
    final requestResult = await Permission.manageExternalStorage.request();
    state = state.copyWith(storageGranted: requestResult.isGranted);
  }

  void checkStoragePermission() async {
    final permissionIsGranted = await Permission.manageExternalStorage.request().isGranted;
    state = state.copyWith(storageGranted: permissionIsGranted);
  }

}

class PermissionState {
  final bool storageGranted;

  PermissionState({
    this.storageGranted = true
  });

  PermissionState copyWith({
    bool? storageGranted
  }) => PermissionState(
    storageGranted: storageGranted ?? this.storageGranted
  );
}