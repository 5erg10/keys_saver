import 'package:flutter/material.dart';
import 'package:keys_saver/config/constants/colors.dart';
import 'package:keys_saver/config/extensions/bold_substring.dart';
import 'package:keys_saver/config/extensions/color_from_hex.dart';
import 'package:keys_saver/domain/models/app_credentials.dart';

class ManualCredentialsForm extends StatefulWidget {

final AppCredentials? userCredentials;
final Function? onSubmit;

  const ManualCredentialsForm({
    super.key,
    required this.userCredentials,
    this.onSubmit
  });

  @override
  State<ManualCredentialsForm> createState() => _UserDataFormState();
}

class _UserDataFormState extends State<ManualCredentialsForm> {

  final TextEditingController userInputCtrl = TextEditingController();
  final TextEditingController passWInputCtrl = TextEditingController();

  bool invalidForm = false;
  bool obscurePassWInputText = true;

  bool formIsValid() {
    return widget.userCredentials == null
      ? userInputCtrl.text.isNotEmpty && passWInputCtrl.text.isNotEmpty
      : passWInputCtrl.text.isNotEmpty && widget.userCredentials!.passW == passWInputCtrl.text;
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

    final bool isUserSaved = widget.userCredentials != null;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SizedBox(
          height: 550.0,
          width: MediaQuery.of(context).size.width - 100,
          child: ListView(
            children: [
              const SizedBox(height: 30.0),
              if (!isUserSaved)
              ... [
                const Text(
                  '* Cree un usuario y contraseña que solo estara almacenado en su dispositivo movil para garantizar su privacidad. Procure memorizar o anotar los datos que introduzca para acceder en adelante',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100),
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
          ),
        ),
      ),
    );
  }
}