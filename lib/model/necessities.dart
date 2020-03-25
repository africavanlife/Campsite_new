import 'package:json_annotation/json_annotation.dart';

part 'necessities.g.dart';

@JsonSerializable()
class NecessitiesModel {
  NecessitiesModel(
      {this.autoParts = false,
      this.cellularNetwork = false,
      this.drinkingWater = false,
      this.electricity = false,
      this.gas = false,
      this.laundary = false,
      this.repairMechanics = false,
      this.shower = false,
      this.toilet = false,
      this.trashbin = false,
      this.water = false,
      this.wifi = false});
  bool water;
  bool electricity;
  bool drinkingWater;
  bool wifi;
  bool shower;
  bool cellularNetwork;
  bool trashbin;
  bool toilet;
  bool repairMechanics;
  bool autoParts;
  bool gas;
  bool laundary;

  factory NecessitiesModel.fromJson(Map<String, dynamic> json) =>
      _$NecessitiesModelFromJson(json);
  Map<String, dynamic> toJson() => _$NecessitiesModelToJson(this);
}
