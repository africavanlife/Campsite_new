// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) {
  return ReviewModel(
    likes: json['likes'] as int,
    rate: json['rate'] as int,
    review: json['review'] as String,
    spotID: json['spotID'] as String,
    userID: json['userID'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'spotID': instance.spotID,
      'rate': instance.rate,
      'likes': instance.likes,
      'review': instance.review,
      'updatedAt': instance.updatedAt,
    };
