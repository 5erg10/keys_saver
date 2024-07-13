import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:keys_saver/presentation/widgets/custom_snackbar.dart';

class DinamycInput extends StatefulWidget {

final String textValue;
final bool isPasswordType;
final Function? onValueChange;
final String? title;
final String? placeholder;
final TextInputType? keyboardType;

const DinamycInput({ 
  super.key,
  required this.textValue,
  this.isPasswordType = false,
  this.onValueChange,
  this.title = 'Undefined title',
  this.placeholder = 'Updated placeholder',
  this.keyboardType = TextInputType.text
});

  @override
  State<DinamycInput> createState() => _DinamycInputState();
}

class _DinamycInputState extends State<DinamycInput> {

  late bool textObscured = false;

  bool isEditing = false;

  final TextEditingController inputController = TextEditingController();
  String inputText = '';
  
  @override
  void initState() {
    super.initState();
    textObscured = widget.isPasswordType;
    inputController.text = widget.textValue;
    inputText = widget.textValue;
  }
  
  @override
  Widget build(BuildContext context){

    void onInputValueChanged(String value) {
     setState(() {
        inputText = value;
      });
      inputController.text = value;
      widget.onValueChange!(value);
    }

    Baseline obscureText(String text) {
      return Baseline(
        baseline: 20,
        baselineType: TextBaseline.alphabetic,
        child: Text('·' * text.length, style: const TextStyle(fontSize: 33.0))
      );
    }

    return Container(
      child: !isEditing
      ? GestureDetector(
        onTap: () {
          CustomSnackbar(
            text: 'Copiado en el portapapeles',
            backGroundColor: Theme.of(context).primaryColor,
            hideTimeout: 3,
            context: context,
            textColor: Theme.of(context).secondaryHeaderColor
          ).showSnackBar();
          Clipboard.setData(ClipboardData(text: inputText));
        },
        child: SizedBox(
          height: 70.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 3.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title ?? '', style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5.0),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 180),
                      child: SizedBox(
                        height: 35.0,
                        child: widget.isPasswordType && textObscured ? obscureText(inputText) : Text(inputText, style: const TextStyle(overflow: TextOverflow.ellipsis)),
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              if (widget.isPasswordType) IconButton(onPressed: () => setState(() { textObscured = !textObscured; }), icon: Icon(textObscured ? Icons.visibility : Icons.visibility_off)),
              IconButton( onPressed: () => setState(() => isEditing = true), icon: const Icon(Icons.edit)),
              // IconButton( 
              //   onPressed: () {
              //     CustomSnackbar(
              //       text: 'Copiado en el portapapeles',
              //       backGroundColor: Theme.of(context).primaryColor,
              //       hideTimeout: 2,
              //       context: context,
              //       textColor: Theme.of(context).secondaryHeaderColor
              //     ).showSnackBar();
              //     Clipboard.setData(ClipboardData(text: inputText));
              //   },
              //   icon: const Icon(Icons.copy_outlined))
            ],
          ),
        ),
      )
      :SizedBox(
        height: 70.0,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                autocorrect: false,
                controller: inputController,
                onChanged: onInputValueChanged,
                keyboardType: widget.keyboardType,
                obscureText: textObscured,
                decoration: InputDecoration(
                  labelText: widget.title ?? '',
                  hintText: widget.placeholder ?? '',
                  suffixIcon:
                  widget.isPasswordType
                  ? IconButton(
                    onPressed: () => setState(() { textObscured = !textObscured; }),
                    icon: Icon(textObscured ? Icons.visibility : Icons.visibility_off)
                  )
                  : IconButton(
                    onPressed: () => setState(() => isEditing = false),
                    icon: const Icon(Icons.close)
                  )
                ),
              ),
            ),
            if (widget.isPasswordType) IconButton( onPressed: () => setState(() => isEditing = false), icon: const Icon(Icons.close))
          ]
        )
      )
    );
  }
}