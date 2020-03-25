import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class ProfileModel {
  ProfileModel(
      {this.id,
      this.profileName,
      this.country,
      this.aboutUs,
      this.vanName,
      this.vehicleType,
      this.instaAcc,
      this.whatsappAcc,
      this.travStatus,
      this.profPic,
      this.coverPic,
      this.isVerified = false});

  @JsonKey(name: '_id')
  String id;
  String profileName;
  String country;
  String aboutUs;
  String vanName;
  String vehicleType;
  String instaAcc;
  String whatsappAcc;
  String travStatus;
  String profPic;
  String coverPic;
  bool isVerified;

  // factory ProfileModel.fromJson(Map<dynamic, dynamic> json) {
  //   return ProfileModel(
  //     id: json["_id"],
  //     profileName: json["profileName"],
  //     country: json["country"],
  //     aboutUs: json["aboutUs"],
  //     vanName: json["vanName"],
  //     vehicleType: json["vehicleType"],
  //     instaAcc: json["instaAcc"],
  //     whatsappAcc: json["whatsappAcc"],
  //     travStatus: json["travStatus"],
  //     profPic: json["profPic"],
  //     coverPic: json["coverPic"],
  //   );
  // }

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
