// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsModel _$NotificationsModelFromJson(Map<String, dynamic> json) {
  return NotificationsModel(
    userID: json['userID'] as String,
    notifications: (json['notifications'] as List)
        ?.map((e) => e == null
            ? null
            : NotifymsgModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isRead: json['isRead'] as bool,
  );
}

Map<String, dynamic> _$NotificationsModelToJson(NotificationsModel instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'notifications': instance.notifications,
      'isRead': instance.isRead,
    };
