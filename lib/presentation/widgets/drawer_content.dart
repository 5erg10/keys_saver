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

class DrawerContent extends ConsumerStatefulWidget {

  const DrawerContent({super.key});

  @override
  DrawerContentState createState() => DrawerContentState();
}

class DrawerContentState extends ConsumerState<DrawerContent> {

  bool autoThemeSelection = true;

  bool darkThemeMode = false;

  AppConfig configParams = AppConfig(enableConfigTheme: false, darkModeEnabled: false);

  Future createDataFile(File dataFile, String dirPath, String fileName) async {

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

  void importCsv() async {

    Directory appDocDir = await getApplicationDocumentsDirectory();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      initialDirectory: appDocDir.path
    );

    if (result != null) {
      File dataFile = File('${result.files.first.path}');
      final input = dataFile.openRead();
      final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
      for (var field in fields) {
        ref.read(keysDataProvider.notifier).addKeyList(KeyValues(titulo: field[0], user: field[1], passW: field[2]));
      }
    }
  }

  void exportCsv() async {

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Selecciona dónde guardar la copia de seguridad',
    );

    if (selectedDirectory == null) return;

    String csvFileName = 'key${DateTime.now().millisecondsSinceEpoch ~/ 1000}';

    File dataFile = File('$selectedDirectory/$csvFileName.csv');

    if (await dataFile.exists()) {
      await dataFile.delete();
    }

    createDataFile(dataFile, selectedDirectory, csvFileName);
  }

  void getAppConfig() async {
    final configs = ref.read(configParamsProvider).configData;
    setState(() {
      configParams = configs;
    });
  }

  @override
  void initState() {
    getAppConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        const SizedBox(height: 100.0),
        const Text('Keys Saver').boldSubString('Keys', Theme.of(context).textTheme.bodyMedium!),
        SizedBox(height: MediaQuery.sizeOf(context).height - 430),
        Row(
          children: [
            TextButton(
              onPressed: exportCsv,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
              ),
              child: Text('Crear copia de seguridad', style: TextStyle( color: HexColor.fromHex(AppColors.secondary700) ))
            )
          ]
        ),
        Row(
          children: [
            TextButton(
              onPressed: importCsv,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
              ),
              child: Text('Importar datos copia de seguridad', style: TextStyle( color: HexColor.fromHex(AppColors.secondary700) ))
            )
          ]
        ),
        const SizedBox(height: 30.0),
        Row(
          children: [
            const SizedBox(
              width: 200.0,
              child: Text('Configurar tema desde la aplicación:')
            ),
            const Spacer(),
            Checkbox(
              value: configParams.enableConfigTheme,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool? value) {
                bool isNativeDarkMode = PlatformDispatcher.instance.platformBrightness == Brightness.dark;
                setState( () {
                  configParams.enableConfigTheme = !configParams.enableConfigTheme;
                  if (!configParams.enableConfigTheme) configParams.darkModeEnabled = isNativeDarkMode;
                });
                final AppConfig newConfig = AppConfig(enableConfigTheme: configParams.enableConfigTheme, darkModeEnabled: configParams.enableConfigTheme ? isNativeDarkMode : configParams.darkModeEnabled);
                ref.read(configParamsProvider.notifier).saveAppConfig(newConfig);
              }
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
              onChanged: configParams.enableConfigTheme ? (bool value) {
                setState( () => configParams.darkModeEnabled = !configParams.darkModeEnabled );
                final AppConfig newConfig = AppConfig(enableConfigTheme: configParams.enableConfigTheme, darkModeEnabled: configParams.darkModeEnabled);
                ref.read(configParamsProvider.notifier).saveAppConfig(newConfig);
              } : null
            )
          ],
        )
      ],
    );
  }
}
