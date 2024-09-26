import 'package:flutter/material.dart';
import 'package:keys_saver/config/constants/colors.dart';
import 'package:keys_saver/config/extensions/color_from_hex.dart';

class RequestStoragePermissionsModal extends StatelessWidget {

  final Function onClick;

  const RequestStoragePermissionsModal({
    super.key,
    required this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Container(
            width: 300,
            height: 200,
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Para poder almacenar las credenciales, es necesario que de permisos a la aplicación.',
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => onClick(),
                      child: Text('Solicitar', style: TextStyle(color: HexColor.fromHex(AppColors.secondary900)),)
                    )
                  ],
                )
              ]
            ),
          ),
        );
  }
}