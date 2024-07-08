// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem(
      catagory: json['catagory'] as String,
      variations: (json['variations'] as List<dynamic>)
          .map((e) => Variation.fromJson(e as Map<String, dynamic>))
          .toList(),
      sharedExtras: (json['shared_extras'] as List<dynamic>?)
          ?.map((e) => Extra.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
      'catagory': instance.catagory,
      'variations': instance.variations.map((e) => e.toJson()).toList(),
      'shared_extras': instance.sharedExtras?.map((e) => e.toJson()).toList(),
    };

Variation _$VariationFromJson(Map<String, dynamic> json) => Variation(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      extras: (json['extras'] as List<dynamic>?)
          ?.map((e) => Extra.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VariationToJson(Variation instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'extras': instance.extras?.map((e) => e.toJson()).toList(),
    };

Extra _$ExtraFromJson(Map<String, dynamic> json) => Extra(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      allowDuplicate: json['allow_duplicate'] as bool?,
    );

Map<String, dynamic> _$ExtraToJson(Extra instance) => <String, dynamic>{
      'allow_duplicate': instance.allowDuplicate,
      'name': instance.name,
      'price': instance.price,
    };

RecipeItem _$RecipeItemFromJson(Map<String, dynamic> json) => RecipeItem(
      menuItemName: json['menu_item_name'] as String,
      varientName: json['varient_name'] as String,
      extras:
          (json['extras'] as List<dynamic>).map((e) => e as String).toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RecipeItemToJson(RecipeItem instance) =>
    <String, dynamic>{
      'menu_item_name': instance.menuItemName,
      'varient_name': instance.varientName,
      'extras': instance.extras,
      'notes': instance.notes,
    };

VaraibleRecipeItem _$VaraibleRecipeItemFromJson(Map<String, dynamic> json) =>
    VaraibleRecipeItem(
      multiplier: (json['multiplier'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$VaraibleRecipeItemToJson(VaraibleRecipeItem instance) =>
    <String, dynamic>{
      'multiplier': instance.multiplier,
      'price': instance.price,
      'notes': instance.notes,
    };
