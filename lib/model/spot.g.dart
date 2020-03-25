// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotModel _$SpotModelFromJson(Map<String, dynamic> json) {
  return SpotModel(
    accessibility: json['accessibility'] == null
        ? null
        : AccessibilityModel.fromJson(
            json['accessibility'] as Map<String, dynamic>),
    activities: json['activities'] == null
        ? null
        : ActivitiesModel.fromJson(json['activities'] as Map<String, dynamic>),
    environment: json['environment'] == null
        ? null
        : EnvironmentModel.fromJson(
            json['environment'] as Map<String, dynamic>),
    images: json['images'] as List,
    location: json['location'] == null
        ? null
        : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
    name: json['name'],
    necessities: json['necessities'] == null
        ? null
        : NecessitiesModel.fromJson(
            json['necessities'] as Map<String, dynamic>),
    spotType: json['spotType'],
    userID: json['userID'],
    spotId: json['_id'] as String,
  );
}

Map<String, dynamic> _$SpotModelToJson(SpotModel instance) => <String, dynamic>{
      '_id': instance.spotId,
      'userID': instance.userID,
      'location': instance.location,
      'name': instance.name,
      'spotType': instance.spotType,
      'accessibility': instance.accessibility,
      'activities': instance.activities,
      'environment': instance.environment,
      'necessities': instance.necessities,
      'images': instance.images,
    };
