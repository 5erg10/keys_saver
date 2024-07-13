import 'package:flutter/material.dart';
import 'package:keys_saver/config/constants/colors.dart';
import 'package:keys_saver/config/extensions/color_from_hex.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';

class KeyEntry extends StatelessWidget {

  final KeyValues entryData;
  final Function onKeyRemove;
  final Function? onkeySelected;

  const KeyEntry({ 
    super.key,
    required this.entryData,
    required this.onKeyRemove,
    this.onkeySelected
  });

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor)
        )
      ),
      width: 50,
      child: InkWell(
        onTap: () => onkeySelected != null ? onkeySelected!(entryData.id) : null, // context.push('/keyDetails/${ entryData.id }');
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: [
              const SizedBox(width: 10.0),
              const Icon(
                Icons.enhance_photo_translate,
                size: 40.0,
              ),
              const SizedBox(width: 20.0),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width/4 * 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entryData.titulo, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 5.0),
                    Text(entryData.user, style: Theme.of(context).textTheme.bodySmall!.copyWith(overflow: TextOverflow.ellipsis))
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => onKeyRemove(entryData.id),
                icon: const Icon(Icons.close),
                iconSize: 20.0,
                color: HexColor.fromHex(AppColors.darkRed),
              )
            ],
          ),
        ),
      ),
    );
  }
}