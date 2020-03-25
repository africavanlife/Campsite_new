// import 'package:json_annotation/json_annotation.dart';
// part 'event.g.dart';
// @JsonSerializable()
// class EventModel {
//   EventModel(
//       {this.about,
//       this.end,
//       this.eventName,
//       this.eventType,
//       this.interests,
//       this.mages,
//       this.spotID,
//       this.start,
//       this.userID});

//   String userID;
//   String eventName;
//   String eventType;
//   String mages;
//   List spotID;
//   String start;
//   String end;
//   String about;
//   List interests;

//   factory EventModel.fromJson(Map<String, dynamic> json) =>
//       _$EventModelFromJson(json);
//   Map<String, dynamic> toJson() => _$EventModelToJson(this);
// }

import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class EventModel {
  EventModel(
      {this.id,
      this.about = "",
      this.end = "",
      this.eventName = "",
      this.eventType = "",
      this.images = "",
      this.interests,
      this.spotID,
      this.start = "",
      this.userID = ""});
  @JsonKey(name: '_id')
  String id;
  String userID;
  String eventName;
  String eventType;
  String images;
  List spotID;
  String start;
  String end;
  String about;
  List interests;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
