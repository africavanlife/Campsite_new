// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return EventModel(
    id: json['_id'] as String,
    about: json['about'] as String,
    end: json['end'] as String,
    eventName: json['eventName'] as String,
    eventType: json['eventType'] as String,
    images: json['images'] as String,
    interests: json['interests'] as List,
    spotID: json['spotID'] as List,
    start: json['start'] as String,
    userID: json['userID'] as String,
  );
}

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userID': instance.userID,
      'eventName': instance.eventName,
      'eventType': instance.eventType,
      'images': instance.images,
      'spotID': instance.spotID,
      'start': instance.start,
      'end': instance.end,
      'about': instance.about,
      'interests': instance.interests,
    };
