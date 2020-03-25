import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Resources {
  static bool isVerified = false;
  static var ip = "35.202.28.78:4444";
  static final Color mainColor = Colors.red;
  static final GlobalKey<NavigatorState> navigationKey =
      GlobalKey<NavigatorState>();

  static final String userId = "17msbglv144k6whhkhc";
  // static final List images = [
  //   // "https://lh3.googleusercontent.com/proxy/FqEb4Vu0WjBPNbxWa-u0F8aLGAxSZaQMUmso9q_DFvyx_EVrny-pCTapVBXBDufZpEkHazdQAKUmdfS1gGH1qGiyYnk9AITJoFY3oJgo2S-U-yP_MtOALA",
  //   "https://www.triplankatours.com/wp-content/uploads/2018/05/14-days-sri-lanka-itinerary-image-6.jpg",
  //   "https://www.ootlah.com/wp-content/uploads/2019/10/Cover1.jpg",
  //   "https://igolanka.com/wp-content/uploads/2019/02/Nine_arch_Bridge-960x490.jpg"
  // ];

  // static final mainWhiteColor = Colors.white;
  // static final mainBlackColor = Colors.black;
  // static final bottomNaviColor = Colors.white;

  static final mainWhiteColor = Colors.black87;
  static final mainBlackColor = Colors.white;
  static final bottomNaviColor = Colors.grey;

  static final List<String> spotType = [
    "Wild Spot",
    "Campsite",
    "RV-Park",
    "Parking"
  ];
  static final List<String> eventType = [
    "Meetup",
    "Campsite Cleanup",
    "Caravan Tours"
  ];

  static BitmapDescriptor wildSpotIconS;
  static BitmapDescriptor parkingIconS;
  static BitmapDescriptor campsiteIconS;
  static BitmapDescriptor rvParkIconS;
  static BitmapDescriptor currLocIconS;
  static setIcons() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/map_wild.bmp')
        .then((wildSpotIcon) {
      wildSpotIconS = wildSpotIcon;
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(), 'assets/map_park.bmp')
          .then((parkingIcon) {
        parkingIconS = parkingIcon;
        BitmapDescriptor.fromAssetImage(
                ImageConfiguration(), 'assets/map_camp.bmp')
            .then((campsiteIcon) {
          campsiteIconS = campsiteIcon;
          BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(), 'assets/map_rv.bmp')
              .then((rvParkIcon) {
            rvParkIconS = rvParkIcon;
            BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(), 'assets/curLoc.bmp')
                .then((currLocIcon) {
              currLocIconS = currLocIcon;
              print("ICONSET");
            });
          });
        });
      });
    });
  }
}
