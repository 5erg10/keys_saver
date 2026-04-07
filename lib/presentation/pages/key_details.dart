import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keys_saver/config/constants/colors.dart';
import 'package:keys_saver/config/extensions/bold_substring.dart';
import 'package:keys_saver/config/extensions/color_from_hex.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';
import 'package:keys_saver/presentation/providers/keys_provider.dart';
import 'package:keys_saver/presentation/widgets/dynamic_input.dart';

class KeyDetails extends ConsumerStatefulWidget {

  final int entryId;

  const KeyDetails({ 
    super.key,
    required this.entryId
  });

  @override
  KeyDetailsState createState() => KeyDetailsState();
}

class KeyDetailsState extends ConsumerState<KeyDetails> {

  bool textObscured = true;

  bool formPristine = true;

  late KeyValues? keyData;

  void getKeyDetails() {
    final List<KeyValues>? keysList = ref.read(keysDataProvider).keysList;
    keyData = keysList?.firstWhere((element) => element.id == widget.entryId);
  }

  Future<bool> _confirmDiscard(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('¿Descartar cambios?'),
            content: const Text('Tienes cambios sin guardar. ¿Seguro que quieres salir?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Salir'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    getKeyDetails();
  }

  @override
  Widget build(BuildContext context){

     void removeFocus() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      });
    }

    void updateKey() {
      ref.read(keysDataProvider.notifier).updateKeyValues(keyData!);
      Navigator.pop(context);
    }

    void onInputValueChanged(String inputName, String value){
      setState(() {
        formPristine = false;
        if( inputName == 'titulo' ) keyData!.titulo = value;
        if( inputName == 'user' ) keyData!.user = value;
        if( inputName == 'passW' ) keyData!.passW = value;
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (formPristine || await _confirmDiscard(context)) {
          if (context.mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
      body: GestureDetector(
        onTap: removeFocus,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                toolbarHeight: 50,
                bottom: PreferredSize(
                  preferredSize: const Size(double.infinity, 5),
                  child: Divider(
                    color: HexColor.fromHex(AppColors.secondary800)
                  )
                ),
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 60.0),
                      const Text('View Key').boldSubString('View', Theme.of(context).textTheme.bodyMedium!)
                    ]
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40.0),
                      DynamicInput(
                        textValue: keyData?.titulo ?? '',
                        title: 'Título: ',
                        placeholder: 'Introduce un titulo',
                        onValueChange: (String value) => onInputValueChanged('titulo', value),
                      ),
                      const SizedBox(height: 20.0),
                      DynamicInput(
                        textValue: keyData?.user ?? '',
                        title: 'Usuario: ',
                        placeholder: 'Introduce el usuario ...',
                        onValueChange: (String value) => onInputValueChanged('user', value),
                      ),
                      const SizedBox(height: 20.0),
                      DynamicInput(
                        textValue: keyData?.passW ?? '',
                        title: 'PassWord: ',
                        placeholder: 'Introduce la contraseña ...',
                        onValueChange: (String value) => onInputValueChanged('passW', value),
                        isPasswordType: true,
                      ),
                      const SizedBox(height: 50.0),
                      FilledButton.icon(
                        onPressed: updateKey,
                        icon: const Icon(Icons.save_outlined),
                        label: Text('Guardar', style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                        style: FilledButton.styleFrom(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          minimumSize: const Size(double.infinity, 50.0),
                          enableFeedback: true,
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
                          iconColor: Theme.of(context).secondaryHeaderColor
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ),
      ),
    ),
  );
  }
}