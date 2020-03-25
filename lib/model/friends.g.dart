// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsModel _$FriendsModelFromJson(Map<String, dynamic> json) {
  return FriendsModel(
    userID: json['userID'] as String,
    friends: json['friends'] as List,
  );
}

Map<String, dynamic> _$FriendsModelToJson(FriendsModel instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'friends': instance.friends,
    };
