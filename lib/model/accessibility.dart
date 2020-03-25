import 'package:json_annotation/json_annotation.dart';

part 'accessibility.g.dart';

@JsonSerializable()
class AccessibilityModel {
  AccessibilityModel(
      {this.forestRoad=false, this.offRoad=false, this.pavedRoute=false, this.unPavedRoad=false});
  bool pavedRoute;
  bool offRoad;
  bool unPavedRoad;
  @JsonKey(name:'ForestRoad')
  bool forestRoad;

  factory AccessibilityModel.fromJson(Map<String, dynamic> json) =>
      _$AccessibilityModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccessibilityModelToJson(this);

}
