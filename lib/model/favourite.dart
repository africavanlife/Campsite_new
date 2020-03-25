import 'package:json_annotation/json_annotation.dart';

part 'favourite.g.dart';

@JsonSerializable()
class FavouriteModel {
  FavouriteModel({this.userID, this.spotID});
  String userID;
  List spotID;

  factory FavouriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavouriteModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavouriteModelToJson(this);
}
