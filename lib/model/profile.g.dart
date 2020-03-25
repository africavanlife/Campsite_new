// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return ProfileModel(
    id: json['_id'] as String,
    profileName: json['profileName'] as String,
    country: json['country'] as String,
    aboutUs: json['aboutUs'] as String,
    vanName: json['vanName'] as String,
    vehicleType: json['vehicleType'] as String,
    instaAcc: json['instaAcc'] as String,
    whatsappAcc: json['whatsappAcc'] as String,
    travStatus: json['travStatus'] as String,
    profPic: json['profPic'] as String,
    coverPic: json['coverPic'] as String,
    isVerified: json['isVerified'] as bool,
  );
}

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'profileName': instance.profileName,
      'country': instance.country,
      'aboutUs': instance.aboutUs,
      'vanName': instance.vanName,
      'vehicleType': instance.vehicleType,
      'instaAcc': instance.instaAcc,
      'whatsappAcc': instance.whatsappAcc,
      'travStatus': instance.travStatus,
      'profPic': instance.profPic,
      'coverPic': instance.coverPic,
      'isVerified': instance.isVerified,
    };
