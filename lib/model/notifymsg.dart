import 'package:json_annotation/json_annotation.dart';

part 'notifymsg.g.dart';

@JsonSerializable()
class NotifymsgModel {
  NotifymsgModel({this.profileId,this.msg,this.url});
  String profileId;
  String msg;
  String url;

  factory NotifymsgModel.fromJson(Map<String, dynamic> json) =>
      _$NotifymsgModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotifymsgModelToJson(this);
}
