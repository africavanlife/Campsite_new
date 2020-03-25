// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessibility.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessibilityModel _$AccessibilityModelFromJson(Map<String, dynamic> json) {
  return AccessibilityModel(
    forestRoad: json['ForestRoad'] as bool,
    offRoad: json['offRoad'] as bool,
    pavedRoute: json['pavedRoute'] as bool,
    unPavedRoad: json['unPavedRoad'] as bool,
  );
}

Map<String, dynamic> _$AccessibilityModelToJson(AccessibilityModel instance) =>
    <String, dynamic>{
      'pavedRoute': instance.pavedRoute,
      'offRoad': instance.offRoad,
      'unPavedRoad': instance.unPavedRoad,
      'ForestRoad': instance.forestRoad,
    };
