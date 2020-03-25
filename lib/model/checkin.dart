import 'package:json_annotation/json_annotation.dart';

part 'checkin.g.dart';

@JsonSerializable()
class CheckinModel {
  CheckinModel({this.spotID, this.userIDs});
  String spotID;
  List userIDs;

  factory CheckinModel.fromJson(Map<String, dynamic> json) =>
      _$CheckinModelFromJson(json);
  Map<String, dynamic> toJson() => _$CheckinModelToJson(this);
}
