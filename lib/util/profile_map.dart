import 'dart:async';

import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:campsite/controller/favorite_controller.dart';
import 'package:campsite/controller/review_controller.dart';
import 'package:campsite/controller/spot_controller.dart';
import 'package:campsite/model/accessibility.dart';
import 'package:campsite/model/activities.dart';
import 'package:campsite/model/environment.dart';
import 'package:campsite/model/favourite.dart';
import 'package:campsite/model/necessities.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/screens/edit_profile.dart';
import 'package:campsite/screens/edit_spot.dart';
import 'package:campsite/screens/spot.dart';
import 'package:campsite/util/icon_buttons.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/util/spot_detail.dart';
import 'package:clustering_google_maps/clustering_google_maps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rating_bar/rating_bar.dart';

class ProfileMap extends StatefulWidget {
  ProfileMap({@required this.spots});
  final List<SpotModel> spots;

  @override
  _ProfileMapState createState() => _ProfileMapState();
}

class _ProfileMapState extends State<ProfileMap> {
  double _zoomLevel = 10;
  SpotModel _selectedSpotModel;

  AccessibilityModel _accessibilityModel = AccessibilityModel();
  ActivitiesModel _activitiesModel = ActivitiesModel();
  EnvironmentModel _environmentModel = EnvironmentModel();
  NecessitiesModel _necessitiesModel = NecessitiesModel();
  bool _progressBarActive = true;
  bool _spotDetailProgress = true;
  Color layerIconColor = Colors.black;
  Color positionIconColor = Colors.black;
  MapType mapType = MapType.normal;

  bool _markerDetailVisibility = false;
  bool show = false;
  CameraPosition _kGooglePlex;
  GoogleMapController _googleMapController;

  double currZoomLevel;
  List<LatLngAndGeohash> list = List();

  // Set<Marker> markers = Set();
  Set<Marker> orginalMarkers = Set();

//////////////////////////////////////////////////////////////////////////////////////
  List _favourite = List();
  getFavourites(String userID) async {
    RequestResult _req =
        await FavouriteController().getByUser(Resources.userId);

    _favourite.clear();
    if (_req.data != null && _req.data.length > 0) {
      setState(() {
        _favourite = (_req.data.first.spotID);
      });
    } else {
      setState(() {});
    }
  }

  Position positionCur = Position(latitude: 0, longitude: 0);
  void _onMapCreated(GoogleMapController mapController) async {
    _googleMapController = mapController;
    positionCur = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(positionCur.latitude, positionCur.longitude),
        zoom: _zoomLevel)));

    // markers.add(Marker(
    //   markerId: MarkerId("currMark"),
    //   position: LatLng(positionCur.latitude, positionCur.longitude),
    //   icon: currLocIcon,
    //   onTap: () {},
    // ));

    setState(() {});
    print("onMapCreated");
  }

  BitmapDescriptor wildSpotIcon;
  BitmapDescriptor parkingIcon;
  BitmapDescriptor campsiteIcon;
  BitmapDescriptor rvParkIcon;
  BitmapDescriptor currLocIcon;

  setIcons() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/map_wild.bmp')
        .then((wildSpotIcon) {
      this.wildSpotIcon = wildSpotIcon;
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(), 'assets/map_park.bmp')
          .then((parkingIcon) {
        this.parkingIcon = parkingIcon;
        BitmapDescriptor.fromAssetImage(
                ImageConfiguration(), 'assets/map_camp.bmp')
            .then((campsiteIcon) {
          this.campsiteIcon = campsiteIcon;
          BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(), 'assets/map_rv.bmp')
              .then((rvParkIcon) {
            this.rvParkIcon = rvParkIcon;
            BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(), 'assets/curLoc.bmp')
                .then((currLocIcon) {
              this.currLocIcon = currLocIcon;
              setState(() {});
            });
          });
        });
      });
    });
    setState(() {});
  }

  List<LatLng> wildSpot = List();
  List<LatLng> parking = List();
  List<LatLng> campsite = List();
  List<LatLng> rvPark = List();
  int _spotRating = 0;
  double _spotDist = 0;
  Map<String, SpotModel> spotMap = Map();

  MarkerId getMarkerID(Marker marker) {
    for (Marker mark in this.orginalMarkers) {
      if (mark.position.latitude == marker.position.latitude &&
          mark.position.longitude == marker.position.longitude) {
        return mark.markerId;
      }
    }

    return marker.markerId;
  }

  void getAllMarkerPlaces() async {
    setState(() {
      wildSpot.clear();
      campsite.clear();
      rvPark.clear();
      parking.clear();
      list.clear();
      spotMap.clear();
      this.orginalMarkers.clear();

      for (SpotModel spotModel in widget.spots) {
        LatLng latlng = LatLng(spotModel.location.coordinates[1],
            spotModel.location.coordinates[0]);

        if (spotModel.spotType.toString() == Resources.spotType[0]) {
          this.orginalMarkers.add(Marker(
                markerId:
                    MarkerId("${latlng.hashCode}_wild@${spotModel.spotId}"),
                position: latlng,
                icon: Resources.wildSpotIconS,
                onTap: () {
                  setState(() {
                    _selectedSpotModel = spotModel;
                    print(_selectedSpotModel.spotId);
                    _markerDetailVisibility = true;
                  });
                },
              ));
          list.add(LatLngAndGeohash(latlng));
          spotMap[spotModel.spotId] = spotModel;
          wildSpot.add(latlng);
        }

        if (spotModel.spotType.toString() == Resources.spotType[1]) {
          this.orginalMarkers.add(Marker(
                markerId:
                    MarkerId("${latlng.hashCode}_camp@${spotModel.spotId}"),
                position: latlng,
                icon: Resources.wildSpotIconS,
                onTap: () {
                  setState(() {
                    print(_selectedSpotModel.spotId);
                    _selectedSpotModel = spotModel;
                    _markerDetailVisibility = true;
                  });
                },
              ));
          list.add(LatLngAndGeohash(latlng));
          spotMap[spotModel.spotId] = spotModel;
          campsite.add(latlng);
        }

        if (spotModel.spotType.toString() == Resources.spotType[2]) {
          this.orginalMarkers.add(Marker(
                markerId: MarkerId("${latlng.hashCode}_rv@${spotModel.spotId}"),
                position: latlng,
                icon: Resources.wildSpotIconS,
                onTap: () {
                  setState(() {
                    print(_selectedSpotModel.spotId);
                    _selectedSpotModel = spotModel;
                    _markerDetailVisibility = true;
                  });
                },
              ));
          list.add(LatLngAndGeohash(latlng));
          spotMap[spotModel.spotId] = spotModel;
          rvPark.add(latlng);
        }

        if (spotModel.spotType.toString() == Resources.spotType[3]) {
          this.orginalMarkers.add(Marker(
                markerId:
                    MarkerId("${latlng.hashCode}_park@${spotModel.spotId}"),
                position: latlng,
                icon: Resources.wildSpotIconS,
                onTap: () {
                  setState(() {
                    print(_selectedSpotModel.spotId);
                    _selectedSpotModel = spotModel;
                    _markerDetailVisibility = true;
                  });
                },
              ));
          list.add(LatLngAndGeohash(latlng));
          spotMap[spotModel.spotId] = spotModel;
          parking.add(latlng);
        }
      }
      setIcons();
      print("SPOT CREATED");
      _progressBarActive = false;
    });
  }

  @override
  void initState() {
    currZoomLevel = _zoomLevel;
    _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: _zoomLevel,
    );

    setIcons();
    getFavourites(Resources.userId);
    getAllMarkerPlaces();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return _progressBarActive == true
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: <Widget>[
              GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                onTap: (argument) {
                  setState(() {
                    // _selectedSpotModel = null;
                    _markerDetailVisibility = false;
                  });
                },
                onMapCreated: _onMapCreated,
                mapType: mapType,
                initialCameraPosition: _kGooglePlex,
                onCameraMove: (newPosition) {
                  setState(() {
                    positionIconColor = Colors.black;
                    currZoomLevel = newPosition.zoom;
                  });
                },
                markers: orginalMarkers,
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Column(
                  children: <Widget>[
                    IconButton(
                        color: layerIconColor,
                        icon: Icon(FontAwesomeIcons.layerGroup),
                        onPressed: () {
                          setState(() {
                            if (mapType == MapType.normal) {
                              mapType = MapType.satellite;
                              layerIconColor = Colors.red;
                            } else {
                              mapType = MapType.normal;
                              layerIconColor = Colors.black;
                            }
                          });
                        }),
                    IconButton(
                      color: positionIconColor,
                      onPressed: () async {
                        setState(() {
                          positionIconColor = Resources.mainColor;
                        });
                        Position position = await Geolocator()
                            .getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high);
                        print(position.latitude);

                        _googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(
                                    position.latitude, position.longitude),
                                zoom: _zoomLevel)));
                      },
                      icon: Icon(FontAwesomeIcons.crosshairs),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
              // _selectedSpotModel == null
              //     ? Container()
              //     :
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Visibility(
                    visible: _markerDetailVisibility,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: sysWidth - 20,
                        height: sysHeight * 0.3,
                        color: Colors.grey[300],
                        child: _spotDetailProgress
                            ? CircularProgressIndicator()
                            : Stack(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SpotScreen(
                                                          _selectedSpotModel,
                                                          _spotRating)));
                                        },
                                        child: Image(
                                          width: (sysWidth - 20) * 0.85,
                                          height: sysHeight * 0.3,
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              _selectedSpotModel.images[0]),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          AIconButtons(
                                            false,
                                            initAct: _favourite.contains(
                                                _selectedSpotModel.spotId),
                                            actImageUrl: "assets/like_act.png",
                                            inactImageUrl:
                                                "assets/like_inactv.png",
                                            onTap: (value) {
                                              print(
                                                  "JJJJJJJJJJJJJJJJJJJJJ  : " +
                                                      _favourite
                                                          .contains(
                                                              _selectedSpotModel
                                                                  .spotId)
                                                          .toString());
                                              if (_favourite.contains(
                                                  _selectedSpotModel.spotId)) {
                                                _favourite.remove(
                                                    _selectedSpotModel.spotId);
                                              } else {
                                                _favourite.add(
                                                    _selectedSpotModel.spotId);
                                              }
                                              FavouriteController()
                                                  .getByUser(Resources.userId)
                                                  .then((value) {
                                                if (value.data.length > 0) {
                                                  FavouriteController()
                                                      .update(Resources.userId,
                                                          _favourite)
                                                      .then((value) {
                                                    getFavourites(
                                                        Resources.userId);
                                                    setState(() {});
                                                  });
                                                } else {
                                                  FavouriteController()
                                                      .save(FavouriteModel(
                                                          spotID: _favourite,
                                                          userID:
                                                              Resources.userId))
                                                      .then((value) {
                                                    getFavourites(
                                                        Resources.userId);
                                                    setState(() {});
                                                  });
                                                }
                                              });
                                            },
                                          ),
                                          IconButton(
                                              icon: ImageIcon(
                                                AssetImage(
                                                    "assets/profile.png"),
                                              ),
                                              onPressed: () {
                                                Resources
                                                    .navigationKey.currentState
                                                    .pushNamed('/viewProfile',
                                                        arguments:
                                                            _selectedSpotModel
                                                                .userID);
                                              }),
                                          IconButton(
                                            icon: ImageIcon(
                                              AssetImage("assets/navigate.png"),
                                            ),
                                            onPressed: () async {
                                              // String googleUrl =
                                              //     'https://www.google.com/maps/search/?api=1&query=${_selectedSpotModel.location.coordinates[1]},${_selectedSpotModel.location.coordinates[0]}';
                                              // if (await canLaunch(googleUrl)) {
                                              //   await launch(googleUrl);
                                              // } else {
                                              //   throw 'Could not open the map.';
                                              // }
                                              Resources.openMapsSheet(
                                                  context,
                                                  LatLng(
                                                      _selectedSpotModel
                                                          .location
                                                          .coordinates[1],
                                                      _selectedSpotModel
                                                          .location
                                                          .coordinates[0]));
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    width: sysWidth * 0.7,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        RatingBar(
                                          initialRating: _spotRating.toDouble(),
                                          maxRating: 5,
                                          onRatingChanged: (rating) {},
                                          filledIcon:
                                              FontAwesomeIcons.solidCircle,
                                          emptyIcon:
                                              FontAwesomeIcons.solidCircle,
                                          isHalfAllowed: false,
                                          filledColor: Colors.red,
                                          emptyColor: Colors.white,
                                          size: 15,
                                        ),
                                        Text(
                                          "$_spotDist KM",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  )),
            ],
          );
  }
}
