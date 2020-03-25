// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnvironmentModel _$EnvironmentModelFromJson(Map<String, dynamic> json) {
  return EnvironmentModel(
    cliff: json['cliff'] as bool,
    desert: json['desert'] as bool,
    lac: json['lac'] as bool,
    mountain: json['mountain'] as bool,
    river: json['river'] as bool,
    sea: json['sea'] as bool,
    waterfall: json['waterfall'] as bool,
  );
}

Map<String, dynamic> _$EnvironmentModelToJson(EnvironmentModel instance) =>
    <String, dynamic>{
      'mountain': instance.mountain,
      'desert': instance.desert,
      'waterfall': instance.waterfall,
      'cliff': instance.cliff,
      'lac': instance.lac,
      'sea': instance.sea,
      'river': instance.river,
    };
