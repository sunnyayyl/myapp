import 'package:flutter/material.dart';
import 'package:myapp/menu_data.dart';

class ExtraMenuManager {
  late List<TextEditingController> extraControllers;
  late List<BaseExtra> extras;
  ExtraMenuManager();
  void reset() {
    extraControllers = [TextEditingController()];
    extras = [];
  }

  void dispose() {
    for (final TextEditingController e in extraControllers) {
      e.dispose();
    }
  }

  void cleanup() {
    for (var index = 0; index < extraControllers.length - 1; index++) {
      if (extraControllers[index].text.isEmpty) {
        extraControllers[index].dispose();
        extraControllers.removeAt(index);
        extras.removeAt(index);
      }
    }
  }

  void update(int index, ExtraEquivalent extraCatalogue) {
    if (index == extraControllers.length - 1) {
      extraControllers.add(TextEditingController());
      update(index, extraCatalogue);
    } else if (index < extraControllers.length - 1) {
      if (extras.length == index) {
        extras.add(PlaceholderExtra());
      }
      if (extraCatalogue[extraControllers[index].text] == null) {
        extras[index] = InvalidExtra();
      } else {
        extras[index] = Extra(
          name: extraControllers[index].text,
          price: extraCatalogue[extraControllers[index].text]!.price,
          allowDuplicate:
              extraCatalogue[extraControllers[index].text]!.allowDuplicate,
        );
      }
    }
    cleanup();
    print(extras);
  }

  Map<String, ExtraMapItem> getFilteredExtras(ExtraEquivalent extraCatalogue) {
    Map<String, ExtraMapItem> filtered = Map.from(extraCatalogue);
    for (BaseExtra e in extras) {
      if (e.runtimeType == Extra) {
        Extra extra = e as Extra;
        if (!(extra.allowDuplicate ?? false)) {
          filtered.remove(extra.name);
        }
      }
    }
    return filtered;
  }
}
