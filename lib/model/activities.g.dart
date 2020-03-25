// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivitiesModel _$ActivitiesModelFromJson(Map<String, dynamic> json) {
  return ActivitiesModel(
    bike: json['bike'] as bool,
    boat: json['boat'] as bool,
    climb: json['climb'] as bool,
    climbing: json['climbing'] as bool,
    diving: json['diving'] as bool,
    fire: json['fire'] as bool,
    iron: json['iron'] as bool,
    jump: json['jump'] as bool,
    safari: json['safari'] as bool,
    snow: json['snow'] as bool,
    surf: json['surf'] as bool,
    wind: json['wind'] as bool,
  );
}

Map<String, dynamic> _$ActivitiesModelToJson(ActivitiesModel instance) =>
    <String, dynamic>{
      'climbing': instance.climbing,
      'surf': instance.surf,
      'climb': instance.climb,
      'fire': instance.fire,
      'boat': instance.boat,
      'iron': instance.iron,
      'wind': instance.wind,
      'bike': instance.bike,
      'safari': instance.safari,
      'diving': instance.diving,
      'jump': instance.jump,
      'snow': instance.snow,
    };
