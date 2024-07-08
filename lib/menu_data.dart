import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_annotation/json_annotation.dart';
part 'menu_data.g.dart';

typedef ExtraEquivalent = Map<String, ExtraMapItem>;
typedef VariationEquivalent = Map<String, VariationMapItem>;
typedef MenuItemEquivalent = VariationEquivalent;
typedef MenuEquivalent = Map<String, MenuItemEquivalent>;
MenuEquivalent toMenuEquivalent(List<MenuItem> menu) {
  MenuEquivalent menuEquivalent = {};
  for (MenuItem item in menu) {
    menuEquivalent[item.catagory] = item.toMap();
  }
  return menuEquivalent;
}

@JsonSerializable()
class MenuItem {
  final String catagory;
  final List<Variation> variations;
  final List<Extra>? sharedExtras;
  MenuItem(
      {required this.catagory, required this.variations, this.sharedExtras});
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    MenuItem item = _$MenuItemFromJson(json);
    for (var element in item.variations) {
      if (element.extras == null) {
        element.extras = item.sharedExtras;
      } else {
        element.extras!.addAll(item.sharedExtras ?? []);
      }
    }

    return item;
  }
  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
  MenuItemEquivalent toMap() {
    MenuItemEquivalent menuItemEquivalent = {};
    for (Variation variation in variations) {
      VariationEquivalent variationEquivalent = variation.toMap();
      menuItemEquivalent.addAll(variationEquivalent);
    }
    return menuItemEquivalent;
  }
}

class VariationMapItem {
  final double price;
  final ExtraEquivalent extras;
  VariationMapItem({required this.price, required this.extras});
}

@JsonSerializable()
class Variation {
  final String name;
  final double price;
  List<Extra>? extras;
  Variation({required this.name, required this.price, this.extras});
  factory Variation.fromJson(Map<String, dynamic> json) =>
      _$VariationFromJson(json);
  Map<String, dynamic> toJson() => _$VariationToJson(this);
  VariationEquivalent toMap() {
    ExtraEquivalent extrasEquiv = {};
    for (Extra e in extras ?? []) {
      extrasEquiv.addAll(e.toMap());
    }

    return {
      name: VariationMapItem(price: price, extras: extrasEquiv),
    };
  }

  static List<Variation> fromMap(VariationEquivalent variation) {
    List<Variation> variationList = [];
    for (MapEntry<String, VariationMapItem> e in variation.entries) {
      variationList.add(Variation(
          name: e.key,
          price: e.value.price,
          extras: Extra.fromMap(e.value.extras)));
    }
    return variationList;
  }
}

sealed class BaseExtra {}

class InvalidExtra implements BaseExtra {
  InvalidExtra();
  @override
  bool operator ==(Object other) => other is InvalidExtra;
}

class PlaceholderExtra implements BaseExtra {
  PlaceholderExtra();
}

class ExtraMapItem {
  final double price;
  final bool? allowDuplicate; // if null, assume false
  ExtraMapItem({required this.price, this.allowDuplicate});
}

@JsonSerializable()
class Extra implements BaseExtra {
  final bool? allowDuplicate; // if null, assume false
  final String name;
  final double price;
  Extra({required this.name, required this.price, this.allowDuplicate});
  factory Extra.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);
  Map<String, dynamic> toJson() => _$ExtraToJson(this);
  ExtraEquivalent toMap() {
    return {name: ExtraMapItem(price: price, allowDuplicate: allowDuplicate)};
  }

  static List<Extra> fromMap(ExtraEquivalent extras) {
    List<Extra> extrasList = [];
    for (MapEntry<String, ExtraMapItem> e in extras.entries) {
      extrasList.add(Extra(
          name: e.key,
          price: e.value.price,
          allowDuplicate: e.value.allowDuplicate));
    }
    return extrasList;
  }
}

Future<MenuEquivalent> getEquivalentMenu(Future<List<MenuItem>> menu) async {
  return toMenuEquivalent(await menu);
}

Future<List<MenuItem>> getMenuData() async {
  String data = await rootBundle.loadString("assets/data.json");

  final dataMap = jsonDecode(data) as List<dynamic>;

  final List<MenuItem> menuItems = List<MenuItem>.from(
      dataMap.map<MenuItem>((dynamic i) => MenuItem.fromJson(i)));
  return menuItems;
}

sealed class BaseRecipeItem {}

@JsonSerializable()
class RecipeItem implements BaseRecipeItem {
  final String menuItemName;
  final String varientName;
  final List<String> extras;
  final String? notes;
  RecipeItem(
      {required this.menuItemName,
      required this.varientName,
      required this.extras,
      this.notes});
  factory RecipeItem.fromJson(Map<String, dynamic> json) =>
      _$RecipeItemFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeItemToJson(this);
  double getPrice(MenuEquivalent menu) {
    double price = 0;
    price += menu[menuItemName]![varientName]!.price;
    for (String extra in extras) {
      price += menu[menuItemName]![varientName]!.extras[extra]!.price;
    }
    return price;
  }
}

@JsonSerializable()
class VaraibleRecipeItem implements BaseRecipeItem {
  final double? multiplier;
  final double? price;
  final String? notes;
  VaraibleRecipeItem({this.multiplier, this.price, this.notes});
  factory VaraibleRecipeItem.fromJson(Map<String, dynamic> json) =>
      _$VaraibleRecipeItemFromJson(json);
  Map<String, dynamic> toJson() => _$VaraibleRecipeItemToJson(this);
}
