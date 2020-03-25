import 'package:json_annotation/json_annotation.dart';

part 'activities.g.dart';

@JsonSerializable()

class ActivitiesModel {
  ActivitiesModel(
      {this.bike=false,
      this.boat=false,
      this.climb=false,
      this.climbing=false,
      this.diving=false,
      this.fire=false,
      this.iron=false,
      this.jump=false,
      this.safari=false,
      this.snow=false,
      this.surf=false,
      this.wind=false});
  bool climbing;
  bool surf;
  bool climb;
  bool fire;
  bool boat;
  bool iron;
  bool wind;
  bool bike;
  bool safari;
  bool diving;
  bool jump;
  bool snow;

  factory ActivitiesModel.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActivitiesModelToJson(this);



}
