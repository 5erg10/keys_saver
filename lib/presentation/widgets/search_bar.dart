import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keys_saver/domain/models/keys_collection.dart';

class KeysSearchBar extends StatefulWidget {

  final List<KeyValues> items;

  const KeysSearchBar({
    super.key,
    required this.items
  });

  @override
  State<KeysSearchBar> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<KeysSearchBar> {

  final SearchController controller = SearchController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: controller,
      isFullScreen: false,
      builder: (BuildContext context, SearchController controller) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            controller.openView();
          },
        );
      },
      suggestionsBuilder:
        (BuildContext context, SearchController controller) {
          final List<KeyValues> filteredItems = widget.items.where((key) { 
            return key.titulo.toLowerCase().contains(controller.text.toLowerCase());
          }).toList();
          return List<ListTile>.generate(filteredItems.length, (int index) {
            return ListTile(
              title: Text(filteredItems[index].titulo),
              onTap: () {
                setState(() {
                  controller.closeView(filteredItems[index].id.toString());
                  context.push('/keyDetails/${ filteredItems[index].id }');
                });
              },
            );
          }
        );
      }
    );
  }
}


