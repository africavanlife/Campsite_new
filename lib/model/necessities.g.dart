// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'necessities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NecessitiesModel _$NecessitiesModelFromJson(Map<String, dynamic> json) {
  return NecessitiesModel(
    autoParts: json['autoParts'] as bool,
    cellularNetwork: json['cellularNetwork'] as bool,
    drinkingWater: json['drinkingWater'] as bool,
    electricity: json['electricity'] as bool,
    gas: json['gas'] as bool,
    laundary: json['laundary'] as bool,
    repairMechanics: json['repairMechanics'] as bool,
    shower: json['shower'] as bool,
    toilet: json['toilet'] as bool,
    trashbin: json['trashbin'] as bool,
    water: json['water'] as bool,
    wifi: json['wifi'] as bool,
  );
}

Map<String, dynamic> _$NecessitiesModelToJson(NecessitiesModel instance) =>
    <String, dynamic>{
      'water': instance.water,
      'electricity': instance.electricity,
      'drinkingWater': instance.drinkingWater,
      'wifi': instance.wifi,
      'shower': instance.shower,
      'cellularNetwork': instance.cellularNetwork,
      'trashbin': instance.trashbin,
      'toilet': instance.toilet,
      'repairMechanics': instance.repairMechanics,
      'autoParts': instance.autoParts,
      'gas': instance.gas,
      'laundary': instance.laundary,
    };
