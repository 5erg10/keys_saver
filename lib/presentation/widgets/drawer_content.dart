import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:keys_saver/config/extensions/bold_substring.dart';
import 'package:keys_saver/domain/models/app_config_collection.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:keys_saver/config/constants/colors.dart';
import 'package:keys_saver/config/extensions/color_from_hex.dart';
import 'package:keys_saver/presentation/providers/providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:csv/csv.dart';
import 'package:keys_saver/presentation/widgets/custom_snackbar.dart';

class DrawerContent extends ConsumerWidget {

  const DrawerContent({super.key});

  Future<void> _createDataFile(File dataFile, String dirPath, String fileName, WidgetRef ref) async {
    List<KeyValues> keysData = ref.read(keysDataProvider).keysList ?? [];

    List<List<String>> dataToSave = [];

    await dataFile.create(recursive: true);

    for (KeyValues element in keysData) {
      dataToSave.add([element.titulo, element.user, element.passW]);
    }

    final csvData = const ListToCsvConverter().convert(dataToSave);

    await dataFile.writeAsString(csvData);

    await OpenFile.open('$dirPath/$fileName.csv', type: "application/vnd.ms-excel");
  }

  void _importCsv(BuildContext context, WidgetRef ref) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      initialDirectory: appDocDir.path,
    );

    if (result == null) return;

    try {
      File dataFile = File('${result.files.first.path}');
      final input = dataFile.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      if (fields.isEmpty) {
        if (context.mounted) {
          CustomSnackbar(
            text: 'El archivo está vacío o no tiene el formato correcto',
            context: context,
          ).showSnackBar();
        }
        return;
      }

      for (var field in fields) {
        if (field.length < 3) continue;
        ref.read(keysDataProvider.notifier).addKeyList(
          KeyValues(titulo: field[0].toString(), user: field[1].toString(), passW: field[2].toString()),
        );
      }

      if (context.mounted) {
        CustomSnackbar(
          text: 'Se importaron ${fields.length} credenciales correctamente',
          context: context,
        ).showSnackBar();
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar(
          text: 'Error al importar: el archivo no tiene el formato esperado',
          backGroundColor: HexColor.fromHex(AppColors.darkRed),
          context: context,
        ).showSnackBar();
      }
    }
  }

  Future<bool> _confirmCsvExport(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Aviso de seguridad'),
            content: const Text(
              'La copia de seguridad se guardará en texto plano (CSV sin cifrar).\n\n'
              'Cualquier persona con acceso al archivo podrá ver todas tus contraseñas.\n\n'
              '¿Deseas continuar?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Exportar igualmente'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _exportCsv(BuildContext context, WidgetRef ref) async {
    final confirmed = await _confirmCsvExport(context);
    if (!confirmed) return;

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Selecciona dónde guardar la copia de seguridad',
    );

    if (selectedDirectory == null) return;

    try {
      String csvFileName = 'key${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
      File dataFile = File('$selectedDirectory/$csvFileName.csv');

      if (await dataFile.exists()) {
        await dataFile.delete();
      }

      await _createDataFile(dataFile, selectedDirectory, csvFileName, ref);

      if (context.mounted) {
        CustomSnackbar(
          text: 'Copia de seguridad guardada correctamente',
          context: context,
        ).showSnackBar();
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar(
          text: 'Error al exportar la copia de seguridad',
          backGroundColor: HexColor.fromHex(AppColors.darkRed),
          context: context,
        ).showSnackBar();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configParams = ref.watch(configParamsProvider).configData;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        const SizedBox(height: 100.0),
        const Text('Keys Saver').boldSubString('Keys', Theme.of(context).textTheme.bodyMedium!),
        SizedBox(height: MediaQuery.sizeOf(context).height - 430),
        Row(
          children: [
            TextButton(
              onPressed: () => _exportCsv(context, ref),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
              ),
              child: Text('Crear copia de seguridad', style: TextStyle(color: HexColor.fromHex(AppColors.secondary700))),
            )
          ],
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => _importCsv(context, ref),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
              ),
              child: Text('Importar datos copia de seguridad', style: TextStyle(color: HexColor.fromHex(AppColors.secondary700))),
            )
          ],
        ),
        const SizedBox(height: 30.0),
        Row(
          children: [
            const SizedBox(
              width: 200.0,
              child: Text('Configurar tema desde la aplicación:'),
            ),
            const Spacer(),
            Checkbox(
              value: configParams.enableConfigTheme,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool? value) {
                final bool isNativeDarkMode =
                    PlatformDispatcher.instance.platformBrightness == Brightness.dark;
                final newConfig = AppConfig(
                  enableConfigTheme: !configParams.enableConfigTheme,
                  darkModeEnabled: !configParams.enableConfigTheme
                      ? isNativeDarkMode
                      : configParams.darkModeEnabled,
                );
                ref.read(configParamsProvider.notifier).saveAppConfig(newConfig);
              },
            )
          ],
        ),
        const SizedBox(height: 30.0),
        Row(
          children: [
            configParams.enableConfigTheme
                ? const Text('Modo oscuro:')
                : Text('Modo oscuro:', style: TextStyle(color: HexColor.fromHex(AppColors.primary300))),
            const Spacer(),
            Switch(
              value: configParams.darkModeEnabled,
              activeColor: Theme.of(context).primaryColor,
              onChanged: configParams.enableConfigTheme
                  ? (bool value) {
                      final newConfig = AppConfig(
                        enableConfigTheme: configParams.enableConfigTheme,
                        darkModeEnabled: !configParams.darkModeEnabled,
                      );
                      ref.read(configParamsProvider.notifier).saveAppConfig(newConfig);
                    }
                  : null,
            )
          ],
        )
      ],
    );
  }
}
