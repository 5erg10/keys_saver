import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keys_saver/config/constants/colors.dart';
import 'package:keys_saver/config/extensions/bold_substring.dart';
import 'package:keys_saver/config/extensions/color_from_hex.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';
import 'package:keys_saver/presentation/providers/keys_provider.dart';

class AddKey extends ConsumerStatefulWidget {

  const AddKey({ super.key });

  @override
  AddKeyState createState() => AddKeyState();
}

class AddKeyState extends ConsumerState<AddKey> {

  final Map<String, TextEditingController> inputControllers = {
    'titleController': TextEditingController(),
    'userController': TextEditingController(),
    'passController': TextEditingController()
  };

  final Map<String, String> inputValues = {
    'titleValue': '',
    'userValue': '',
    'passWValue': '',
  };

  Map<String, String> inputErrorTexts = {
    'titulo': '',
    'user': '',
    'passW': ''
  };

  bool textObscured = true;

  @override
  Widget build(BuildContext context){

     void removeFocus() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      });
    }

    void saveNewKey() {

      bool formIsValid = true;

      setState(() {
        inputErrorTexts = {
          'titulo': inputValues['titleValue']!.isNotEmpty ? '' : 'Debes poner un titulo para las credenciales',
          'user':  inputValues['userValue']!.isNotEmpty ? '' : 'Debes indicar el nombre de usuario con el que se accede',
          'passW':  inputValues['passWValue']!.isNotEmpty ? '' : 'Debes guardar la contraseña que usas para acceder',
        };
      });

      inputErrorTexts.forEach( (errorKey, errorValue) {
        if (errorValue.isNotEmpty) {
          formIsValid = false;
        }
      });

      if ( formIsValid ) {
        final newKey = KeyValues(titulo: inputValues['titleValue']!, user: inputValues['userValue']!, passW: inputValues['passWValue']!);
        ref.read(keysDataProvider.notifier).addKeyList(newKey);
        Navigator.pop(context);
      }
    }

    return Scaffold(
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
                      // IconButton(onPressed: () => { context.pop() }, icon: const Icon(Icons.arrow_back)),
                      const SizedBox(width: 60.0),
                      const Text('Save Key').boldSubString('Save', Theme.of(context).textTheme.bodyMedium!)
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
                      TextFormField(
                        controller: inputControllers['titleController'],
                        onChanged: (value) {
                          if (value.isNotEmpty) setState(() => inputErrorTexts['titulo'] = '');
                          inputValues['titleValue'] = value;
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Titulo:',
                          hintText: 'Introduce un titulo'
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ErrorText(text: inputErrorTexts['titulo']!),
                      ),
                      TextFormField(
                        controller: inputControllers['userController'],
                        onChanged: (value) {
                          if (value.isNotEmpty) setState(() => inputErrorTexts['user'] = '');
                          inputValues['userValue'] = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Usuario:',
                          hintText: 'Introduce tu usuario'
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ErrorText(text: inputErrorTexts['user']!),
                      ),
                      TextFormField(
                        controller: inputControllers['passController'],
                        onChanged: (value) {
                          if (value.isNotEmpty) setState(() => inputErrorTexts['passW'] = '');
                          inputValues['passWValue'] = value;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Contraseña:',
                          hintText: 'Introduce la contraseña',
                          suffixIcon: IconButton(
                            onPressed: () => {
                              setState(() {
                                textObscured = !textObscured;
                              })
                            },
                            icon: Icon(textObscured ? Icons.visibility : Icons.visibility_off)
                          )
                        ),
                        obscureText: textObscured,
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ErrorText(text: inputErrorTexts['passW']!),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: saveNewKey,
                        icon: const Icon(Icons.save_outlined),
                        label: Text('Guardar', style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                        style: FilledButton.styleFrom(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
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
    );
  }
}

class ErrorText extends StatelessWidget {

  final String text;

  const ErrorText({ super.key, required this.text });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text, 
          style: TextStyle(
            fontSize: 12.0, 
            color: HexColor.fromHex(AppColors.lightRed)
          )
        )
      ),
    );
  }
}