import 'package:campsite/model/accessibility.dart';
import 'package:campsite/model/activities.dart';
import 'package:campsite/model/environment.dart';
import 'package:campsite/model/location.dart';
import 'package:campsite/model/necessities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spot.g.dart';

@JsonSerializable()
class SpotModel {
  SpotModel(
      {this.accessibility,
      this.activities,
      this.environment,
      this.images,
      this.location,
      this.name = "",
      this.necessities,
      this.spotType = "",
      this.userID = "",
      this.spotId});
  @JsonKey(name: '_id')
  String spotId;
  var userID;
  @JsonKey(name: 'location')
  LocationModel location;
  var name;
  var spotType;
  @JsonKey(name: 'accessibility')
  AccessibilityModel accessibility;
  @JsonKey(name: 'activities')
  ActivitiesModel activities;
  @JsonKey(name: 'environment')
  EnvironmentModel environment;
  @JsonKey(name: 'necessities')
  NecessitiesModel necessities;
  List images;

  factory SpotModel.fromJson(Map<String, dynamic> json) =>
      _$SpotModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpotModelToJson(this);
}
