// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifymsg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifymsgModel _$NotifymsgModelFromJson(Map<String, dynamic> json) {
  return NotifymsgModel(
    profileId: json['profileId'] as String,
    msg: json['msg'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$NotifymsgModelToJson(NotifymsgModel instance) =>
    <String, dynamic>{
      'profileId': instance.profileId,
      'msg': instance.msg,
      'url': instance.url,
    };
