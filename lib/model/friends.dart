import 'package:json_annotation/json_annotation.dart';

part 'friends.g.dart';

@JsonSerializable()
class FriendsModel {
  FriendsModel({this.userID, this.friends});
  String userID;
  List friends;

  factory FriendsModel.fromJson(Map<String, dynamic> json) =>
      _$FriendsModelFromJson(json);
  Map<String, dynamic> toJson() => _$FriendsModelToJson(this);
}
