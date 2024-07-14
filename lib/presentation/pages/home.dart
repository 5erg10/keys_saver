import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:keys_saver/config/constants/colors.dart';

import 'package:keys_saver/config/extensions/bold_substring.dart';
import 'package:keys_saver/config/extensions/color_from_hex.dart';
import 'package:keys_saver/domain/models/app_config_collection.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';
import 'package:keys_saver/presentation/providers/app_config_provider.dart';
import 'package:keys_saver/presentation/providers/keys_provider.dart';
import 'package:keys_saver/presentation/widgets/key_entry.dart';
// import 'package:keys_saver/presentation/widgets/searchbar.dart';

class Home extends ConsumerStatefulWidget {

  const Home({ super.key });

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
    
  bool darkThemeMode = false;
  bool autoThemeSelection = false;
  bool openedSearchbar = false;
  List<KeyValues> filteredKeys = [];
  final TextEditingController searchInputCtrl = TextEditingController();
  FocusNode inputFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    ref.read(keysDataProvider.notifier).getKeysList();
  }

  @override
  Widget build(BuildContext context) {

    final keysProvider = ref.watch(keysDataProvider);

    final AppConfig configParams = ref.read(configParamsProvider).configData;

    darkThemeMode = configParams.darkModeEnabled;
    autoThemeSelection = configParams.enableConfigTheme;

    void filterKeys(String value) {
      setState(() {
        filteredKeys = keysProvider.keysList!.where((key) { 
            return key.titulo.toLowerCase().contains(value.toLowerCase());
          }).toList();
      });
    }

    if(keysProvider.updated) {
      setState(() {
        searchInputCtrl.text.isEmpty ? filteredKeys = keysProvider.keysList! : filterKeys(searchInputCtrl.text);
      });
    }

    void removeFocus() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      });
    }

    void keyRemove(int id) async {
      ref.read(keysDataProvider.notifier).removeFromKeyList(id);
    }

    void restartValues() {
      setState(() {
        searchInputCtrl.text = '';
        openedSearchbar = false;
        filteredKeys = keysProvider.keysList!;
      });
    }

    void onKeySelected(int keyId) {
      restartValues();
      context.push('/keyDetails/$keyId');
    }

    void showConfirmModal(int id) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            decoration: BoxDecoration(
              // color: HexColor.fromHex(AppColors.primary600),
              border: Border(
                top: BorderSide(
                  width: 2.0,
                  color: Theme.of(context).primaryColor
                )
              ),
            ),
            child: SizedBox(
              height: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('¿Seguro que quiere eliminar este registro?'),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).disabledColor
                        ),
                        child: Text('No', style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                      ),
                      ElevatedButton(
                        child: Text( 'Si', style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                        onPressed: () {
                          keyRemove(id);
                          Navigator.pop(context, true);
                        }
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          restartValues();
          context.push('/addKey');
        },
        shape: const CircleBorder(),
        mini: true,
        child: Icon(Icons.add, color: Theme.of(context).secondaryHeaderColor),
      ),
      body: GestureDetector(
        onTap: removeFocus,
        child: Builder(
          builder: (context) => SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  toolbarHeight: 50,
                  automaticallyImplyLeading: false,
                  bottom: PreferredSize(
                    preferredSize: const Size(double.infinity, 5.0),
                    child: Divider(
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.settings), color: Theme.of(context).primaryColor),
                        Padding(padding: const EdgeInsets.only(right: 10.0) ,child: const Text('Keys Saver').boldSubString('Keys', Theme.of(context).textTheme.bodyMedium!)),
                        Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: [
                            AnimatedSize(
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 200),
                              child: SizedBox(
                                width: openedSearchbar ? MediaQuery.of(context).size.width/3 * 1.5 : 0.0,
                                child: TextField(
                                  focusNode: inputFocus,
                                  controller: searchInputCtrl,
                                  onChanged: filterKeys,
                                )
                              )
                            ),
                            IconButton(onPressed: () => setState(() { inputFocus.requestFocus(); openedSearchbar = !openedSearchbar;}), icon: const Icon(Icons.search), color: Theme.of(context).primaryColor),
                          ]
                        )
                        // KeysSearchBar(items: keysProvider)
                      ]
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: filteredKeys.isEmpty ? 1 : filteredKeys.length,
                  itemBuilder: (BuildContext context, int index) {
                    return filteredKeys.isEmpty 
                    ? SizedBox(
                        height: 200.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (keysProvider.keysList != null && keysProvider.keysList!.isNotEmpty)
                              ... [
                                const Text('No se han encontrado resultados para'),
                                Text('"${searchInputCtrl.text}".')
                              ] else const Text('No tienes contraseñas guardadas aún.'),
                            ]
                          ),
                        )
                      )
                    : SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KeyEntry(
                              entryData: filteredKeys[index],
                              onKeyRemove: showConfirmModal,
                              onkeySelected: onKeySelected,
                            ),
                            if (index == filteredKeys.length - 1) Container(height: 50.0)
                          ],
                        ),
                      )
                    );
                  }
                )
              ],
            ),
          ),
        ),
      ),
      drawerEnableOpenDragGesture: true,
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          children: [
            const SizedBox(height: 100.0),
            const Text('Keys Saver').boldSubString('Keys', Theme.of(context).textTheme.bodyMedium!),
            SizedBox(height: MediaQuery.sizeOf(context).height - 350),
            Row(
              children: [
                 const SizedBox(
                  width: 200.0,
                  child: Text('Configurar tema desde la aplicación:')
                 ),
                 const Spacer(),
                 Checkbox(
                  value: autoThemeSelection,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (bool? value) {
                    setState( () => autoThemeSelection = !autoThemeSelection );
                    final newConfig = configParams;
                    newConfig.enableConfigTheme = autoThemeSelection;
                    newConfig.darkModeEnabled = darkThemeMode;
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
                 : Text('Modo oscuro:', style: TextStyle(color: HexColor.fromHex(AppColors.primary100))),
                 const Spacer(),
                 Switch(
                  value: darkThemeMode,
                  activeColor: Theme.of(context).primaryColor, 
                  onChanged: configParams.enableConfigTheme ? (bool value) {
                    setState( () => darkThemeMode = !darkThemeMode );
                    final newConfig = configParams;
                    newConfig.enableConfigTheme = autoThemeSelection;
                    newConfig.darkModeEnabled = darkThemeMode;
                    ref.read(configParamsProvider.notifier).saveAppConfig(newConfig);
                  } : null
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}