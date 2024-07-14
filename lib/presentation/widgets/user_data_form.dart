import 'package:flutter/material.dart';
import 'package:keys_saver/config/constants/colors.dart';
import 'package:keys_saver/config/extensions/bold_substring.dart';
import 'package:keys_saver/config/extensions/color_from_hex.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';

class UserDataForm extends StatefulWidget {

final AppCredentials userCredentials;
final Function? onSubmit;

  const UserDataForm({
    super.key,
    required this.userCredentials,
    this.onSubmit
  });

  @override
  State<UserDataForm> createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {

  final TextEditingController userInputCtrl = TextEditingController();
  final TextEditingController passWInputCtrl = TextEditingController();

  bool invalidForm = false;
  bool obscurePassWInputText = true;

  bool formIsValid() {
    return widget.userCredentials.user!.isEmpty 
      ? userInputCtrl.text.isNotEmpty && passWInputCtrl.text.isNotEmpty
      : passWInputCtrl.text.isNotEmpty && widget.userCredentials.passW == passWInputCtrl.text;
  }

  void onSubmitPressed() {
    if (formIsValid()) {
      setState(() {
        invalidForm = false;
      });
      widget.onSubmit!(userInputCtrl.text, passWInputCtrl.text);
    } else {
      setState(() {
        invalidForm = true;
      });
    }
  }

  @override
  Widget build(BuildContext context){

    final bool isUserSaved = widget.userCredentials.user!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30.0),
        if (!isUserSaved)
        ... [
          const Text(
            '* No dispone de ningún sistema de autenticación biometrica, es necesario que cree un usuario y contraseña. Este usuario y contraseña solo estara almacenado en su dispositivo movil para garantizar su provacidad. Procure memorizar o anotar los datos que introduzca para acceder en adelante',
            style: TextStyle(fontSize: 12.0),
          ).boldSubString('Procure memorizar o anotar los datos que introduzca para acceder en adelante', const TextStyle(fontSize: 12.0)),
          const SizedBox(height: 50.0),
          TextFormField(
            controller: userInputCtrl,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Usuario:',
              hintText: 'Introduce un nombre de usuario ...'
            ),
          ),
          const SizedBox(height: 30.0),
        ],
        TextFormField(
          controller: passWInputCtrl,
          autocorrect: false,
          keyboardType: TextInputType.text,
          obscureText: obscurePassWInputText,
          decoration: InputDecoration(
            labelText: 'Contraseña:',
            hintText: !isUserSaved ? 'Introduce una contraseña ...' : 'Introduzca la contraseña',
            suffixIcon: IconButton(
              onPressed: () => setState(() { obscurePassWInputText = !obscurePassWInputText; }),
              icon: Icon(obscurePassWInputText ? Icons.visibility : Icons.visibility_off)
            )
          ),
        ),
        if (invalidForm)
        ... [
          const SizedBox(height: 10.0),
          Text( !isUserSaved ? 'Debe introducir un usuario y contraseña' : 'La contraseña introducida no es correcta', style: TextStyle(fontSize: 12.0, color: HexColor.fromHex(AppColors.darkRed))),
        ]
        else const SizedBox(height: 30.0,),
        const SizedBox(height: 20.0),
        FilledButton.icon(
          onPressed: widget.onSubmit != null ? onSubmitPressed : null,
          icon: Icon(
            !isUserSaved ? Icons.save_outlined : Icons.login,
            color:  Theme.of(context).secondaryHeaderColor
          ),
          label: Text(!isUserSaved ? 'Guardar' : 'Acceder', style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
          style: FilledButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
            minimumSize: const Size(double.infinity, 50.0),
            enableFeedback: true,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).textTheme.bodyMedium!.color
          )
        )
      ]
    );
  }
}