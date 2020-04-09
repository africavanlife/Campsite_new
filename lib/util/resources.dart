import 'package:campsite/controller/notification_controller.dart';
import 'package:campsite/model/notifications.dart';
import 'package:campsite/model/notifymsg.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

class Resources {
  static bool isVerified = false;
  static double addSpotZoomLevel = 19;
  // static var ip = "192.168.8.101:4444";
  static var ip = "35.202.28.78:4444";
  static final Color mainColor = Colors.red;
  static final GlobalKey<NavigatorState> navigationKey =
      GlobalKey<NavigatorState>();
  static final String googleAPIKey = "AIzaSyD2POtiebHnl3MuwvxpYn1ALabp4Z05o64";

  static String userId = "17msbglv144k6whhkhc";
  // static String userId = "";
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

  static Future<void> addNotifications(
      String user, NotifymsgModel notifymsg) async {
    RequestResult notifications =
        await NotificationsController().getByUser(user);
    if (notifications.data.length < 1) {
      List lst = [];
      lst.add(notifymsg);
      await NotificationsController()
          .save(NotificationsModel(userID: user, notifications: lst));
    } else {
      List lst = notifications.data.first.notifications;
      await NotificationsController().update(Resources.userId, lst);
    }
  }

  static Future<List> getNotifications() async {
    RequestResult notifications =
        await NotificationsController().getByUser(Resources.userId);
    if (notifications.data.length > 0) {
      return notifications.data;
    } else {
      return [];
    }
  }

  static openMapsSheet(BuildContext context, LatLng latLng) async {
    try {
      final coords = Coords(latLng.latitude, latLng.longitude);
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: "",
                          description: "",
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
