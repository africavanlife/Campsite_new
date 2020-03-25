import 'package:campsite/model/spot.dart';
import 'package:json_annotation/json_annotation.dart';

part 'SpotSeparate.g.dart';

@JsonSerializable()
class SpotSeparateModel {
  SpotSeparateModel({this.campsite, this.parking, this.rvPark, this.wildSpots});
  List<SpotModel> wildSpots;
  List<SpotModel> campsite;
  List<SpotModel> rvPark;
  List<SpotModel> parking;

  factory SpotSeparateModel.fromJson(Map<String, dynamic> json) =>
      _$SpotSeparateModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpotSeparateModelToJson(this);
}
