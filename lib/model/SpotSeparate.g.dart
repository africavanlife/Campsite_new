// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SpotSeparate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotSeparateModel _$SpotSeparateModelFromJson(Map<String, dynamic> json) {
  return SpotSeparateModel(
    campsite: (json['campsite'] as List)
        ?.map((e) =>
            e == null ? null : SpotModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    parking: (json['parking'] as List)
        ?.map((e) =>
            e == null ? null : SpotModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    rvPark: (json['rvPark'] as List)
        ?.map((e) =>
            e == null ? null : SpotModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    wildSpots: (json['wildSpots'] as List)
        ?.map((e) =>
            e == null ? null : SpotModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SpotSeparateModelToJson(SpotSeparateModel instance) =>
    <String, dynamic>{
      'wildSpots': instance.wildSpots,
      'campsite': instance.campsite,
      'rvPark': instance.rvPark,
      'parking': instance.parking,
    };
