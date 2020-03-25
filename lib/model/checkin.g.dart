// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckinModel _$CheckinModelFromJson(Map<String, dynamic> json) {
  return CheckinModel(
    spotID: json['spotID'] as String,
    userIDs: json['userIDs'] as List,
  );
}

Map<String, dynamic> _$CheckinModelToJson(CheckinModel instance) =>
    <String, dynamic>{
      'spotID': instance.spotID,
      'userIDs': instance.userIDs,
    };
