// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavouriteModel _$FavouriteModelFromJson(Map<String, dynamic> json) {
  return FavouriteModel(
    userID: json['userID'] as String,
    spotID: json['spotID'] as List,
  );
}

Map<String, dynamic> _$FavouriteModelToJson(FavouriteModel instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'spotID': instance.spotID,
    };
