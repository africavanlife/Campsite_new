import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class ReviewModel {
  ReviewModel(
      {this.likes = 0,
      this.rate = 0,
      this.review = "",
      this.spotID = "",
      this.userID = "",
      this.updatedAt = ""});
  String userID;
  String spotID;
  int rate;
  int likes;
  String review;
  String updatedAt;
  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}
