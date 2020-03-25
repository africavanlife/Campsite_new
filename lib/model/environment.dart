import 'package:json_annotation/json_annotation.dart';

part 'environment.g.dart';


@JsonSerializable()
class EnvironmentModel {
  EnvironmentModel(
      {this.cliff=false,
      this.desert=false,
      this.lac=false,
      this.mountain=false,
      this.river=false,
      this.sea=false,
      this.waterfall=false});
  bool mountain;
  bool desert;
  bool waterfall;
  bool cliff;
  bool lac;
  bool sea;
  bool river;

  
  factory EnvironmentModel.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$EnvironmentModelToJson(this);

}
