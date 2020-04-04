import 'package:campsite/model/notifymsg.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notifications.g.dart';

@JsonSerializable()
class NotificationsModel {
  NotificationsModel({this.userID, this.notifications, this.isRead = false});
  String userID;
  List<NotifymsgModel> notifications;
  bool isRead;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsModelToJson(this);
}
