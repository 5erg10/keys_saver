import 'package:flutter/material.dart';

class PrivateKeyForm extends StatefulWidget {

  final Function? onSubmit;

  const PrivateKeyForm({
    super.key,
    this.onSubmit
  });

  @override
  PrivateKeyFormState createState() => PrivateKeyFormState();
}

class PrivateKeyFormState extends State<PrivateKeyForm> {

  final TextEditingController privKeyInputCtrl = TextEditingController();
  bool obscurePrivKeyInputText = true;
  String inputValue = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: SizedBox(
          height: 450.0,
          width: MediaQuery.of(context).size.width - 100,
          child: ListView(
            children: [
              const Text('Generar passkey: ', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10.0,),
              const Text('Esta clave es una frase que solo la tienes que introducir una vez y no es necesario que la memorices. Puede ser una frase con sentido o letras y números aleatorios, simplemente servirá como clave para encriptar a partir de ese momento todos tus datos y que esten seguros almacenados en tu dispositivo'),
              const SizedBox(height: 30.0),
              TextFormField(
                maxLength: 32,
                autocorrect: false,
                controller: privKeyInputCtrl,
                onChanged: (value) => setState(() => inputValue = value),
                keyboardType: TextInputType.text,
                obscureText: obscurePrivKeyInputText,
                decoration: InputDecoration(
                  labelText: 'Clave Privada:',
                  hintText: 'Introduce una clave ...',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() { obscurePrivKeyInputText = !obscurePrivKeyInputText; }),
                    icon: Icon(obscurePrivKeyInputText ? Icons.visibility : Icons.visibility_off)
                  )
                ),
              ),
              const SizedBox(height: 30.0),
              FilledButton.icon(
                onPressed: widget.onSubmit != null && 32 - inputValue.length == 0 ? () => widget.onSubmit!(inputValue) : null,
                icon: Icon(Icons.save_outlined, color:  Theme.of(context).secondaryHeaderColor),
                label: Text('Guardar', style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                style: FilledButton.styleFrom(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                  minimumSize: const Size(double.infinity, 50.0),
                  enableFeedback: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).textTheme.bodyMedium!.color
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}