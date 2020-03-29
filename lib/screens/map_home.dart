import 'dart:async';

import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:campsite/controller/favorite_controller.dart';
import 'package:campsite/controller/review_controller.dart';

import 'package:campsite/controller/spot_controller.dart';
import 'package:campsite/model/SpotSeparate.dart';
import 'package:campsite/model/accessibility.dart';
import 'package:campsite/model/activities.dart';
import 'package:campsite/model/environment.dart';
import 'package:campsite/model/favourite.dart';
import 'package:campsite/model/necessities.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/resources/RequestResult.dart';

import 'package:campsite/screens/spot.dart';
import 'package:campsite/util/icon_buttons.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/util/spot_detail.dart';
import 'package:clustering_google_maps/clustering_google_maps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rating_bar/rating_bar.dart';

class MapHomeScreen extends StatefulWidget {
  MapHomeScreen(this.drawerKey);
  final drawerKey;
  @override
  _MapHomeScreenState createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  int _nearestPlaces = 0;
  SpotModel _selectedSpotModel;
  SpotModel _filterSpotModel = SpotModel();
  List<String> _filterSpotTypes = List();
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
  bool _filterScreenVisibility = false;
  double _filterSliderVal = 170;
  bool show = false;
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GoogleMapController _googleMapController;

  double currZoomLevel = 15;
  List<LatLngAndGeohash> list = List();

  ClusteringHelper clusteringHelper;

  Set<Marker> markers = Set();
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
    positionCur = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(positionCur.latitude, positionCur.longitude),
        zoom: 15)));

    // markers.add(Marker(
    //   markerId: MarkerId("currMark"),
    //   position: LatLng(positionCur.latitude, positionCur.longitude),
    //   icon: currLocIcon,
    //   onTap: () {},
    // ));

    setState(() {});
    print("onMapCreated");
    _googleMapController = mapController;
    clusteringHelper.mapController = mapController;
    clusteringHelper.updateMap();
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

  updateMarkers(Set<Marker> markers) {
    setState(() {
      Set<Marker> tmpMarkers = Set();
      for (Marker marker in markers) {
        MarkerId markerID = getMarkerID(marker);

        tmpMarkers.add(Marker(
          markerId: markerID,
          position: marker.position,
          icon: markerID.value.contains("_wild")
              ? wildSpotIcon
              : markerID.value.contains("_park")
                  ? parkingIcon
                  : markerID.value.contains("_camp")
                      ? campsiteIcon
                      : markerID.value.contains("_rv")
                          ? rvParkIcon
                          : marker.icon,
          onTap: () async {
            if (markerID.value.contains('_wild') ||
                markerID.value.contains('_park') ||
                markerID.value.contains('_camp') ||
                markerID.value.contains('_rv')) {
              setState(() {
                _spotDetailProgress = true;
                _markerDetailVisibility = true;
                _selectedSpotModel = spotMap[markerID.value.split("@")[1]];
              });

              var rate = await ReviewController()
                  .getReviewBySpotId(_selectedSpotModel.spotId);
              double distanceInMeters = await Geolocator().distanceBetween(
                  positionCur.latitude,
                  positionCur.longitude,
                  _selectedSpotModel.location.coordinates[1],
                  _selectedSpotModel.location.coordinates[0]);
              setState(() {
                _spotDist =
                    double.parse((distanceInMeters / 1000).toStringAsFixed(2));
                _spotRating = rate;
                _spotDetailProgress = false;
              });
            } else {
              setState(() {
                currZoomLevel += 3;
                _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(marker.position.latitude,
                            marker.position.longitude),
                        zoom: currZoomLevel)));
              });
            }
          },
        ));
      }

      this.markers = tmpMarkers;
      // this.markers.add(Marker(
      //       markerId: MarkerId("currMark"),
      //       position: LatLng(positionCur.latitude, positionCur.longitude),
      //       icon: currLocIcon,
      //       onTap: () {},
      //     ));
    });
  }

  initMemoryClustering() {
    clusteringHelper = ClusteringHelper.forMemory(
      list: list,
      updateMarkers: updateMarkers,
      aggregationSetup: AggregationSetup(
        markerSize: 100,
      ),
    );
  }

// isFilter for reset
  filterSpot(bool isFilter) {
    if (isFilter) {
      SpotController()
          .filterBySpot(
              _filterSpotTypes,
              _filterSpotModel,
              positionCur.latitude,
              positionCur.longitude,
              _filterSliderVal.toInt() * 1000)
          .then((result) => {
                if (result.ok)
                  {
                    print(result.data.length),
                    setState(() {
                      wildSpot.clear();
                      campsite.clear();
                      rvPark.clear();
                      parking.clear();
                      list.clear();
                      spotMap.clear();
                      this.orginalMarkers.clear();

                      for (SpotModel spotModel in result.data) {
                        LatLng latlng = LatLng(
                            spotModel.location.coordinates[1],
                            spotModel.location.coordinates[0]);

                        if (spotModel.spotType.toString() ==
                            Resources.spotType[0]) {
                          this.orginalMarkers.add(Marker(
                                markerId: MarkerId(
                                    "${latlng.hashCode}_wild@${spotModel.spotId}"),
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

                        if (spotModel.spotType.toString() ==
                            Resources.spotType[1]) {
                          this.orginalMarkers.add(Marker(
                                markerId: MarkerId(
                                    "${latlng.hashCode}_camp@${spotModel.spotId}"),
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

                        if (spotModel.spotType.toString() ==
                            Resources.spotType[2]) {
                          this.orginalMarkers.add(Marker(
                                markerId: MarkerId(
                                    "${latlng.hashCode}_rv@${spotModel.spotId}"),
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

                        if (spotModel.spotType.toString() ==
                            Resources.spotType[3]) {
                          this.orginalMarkers.add(Marker(
                                markerId: MarkerId(
                                    "${latlng.hashCode}_park@${spotModel.spotId}"),
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
                      _filterScreenVisibility = false;
                      initMemoryClustering();

                      getNearestPlace(
                        5000,
                        filter: true,
                        lat: positionCur.latitude,
                        long: positionCur.longitude,
                        spotModel: _filterSpotModel,
                        spotTypes: _filterSpotTypes,
                      );
                      clusteringHelper.updateMap();
                    })
                  }
              });
    } else {
      getAllMarkerPlaces();
      _filterScreenVisibility = false;
      initMemoryClustering();
      getNearestPlace(5000, filter: true);
      clusteringHelper.updateMap();
    }
  }

  @override
  void initState() {
    // getAddress();
    _filterSpotModel.accessibility = _accessibilityModel;
    _filterSpotModel.activities = _activitiesModel;
    _filterSpotModel.necessities = _necessitiesModel;
    _filterSpotModel.environment = _environmentModel;
    setIcons();
    getFavourites(Resources.userId);
    // getAllSpots();
    getAllMarkerPlaces();
    super.initState();
    initMemoryClustering();
    getNearestPlace(5000);
  }

  void getNearestPlace(int dist,
      {bool filter = false,
      List spotTypes,
      SpotModel spotModel,
      double lat,
      double long}) async {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) {
      if (!filter) {
        SpotController()
            .getNearBy(dist, position.latitude, position.longitude)
            .then((result) {
          if (result.ok) {
            setState(() {
              _nearestPlaces = result.data.length;
            });
          }
        });
      } else {
        SpotController()
            .filterBySpot(spotTypes, spotModel, lat, long, dist)
            .then((result) {
          if (result.ok) {
            setState(() {
              _nearestPlaces = result.data.length;
            });
          }
        });
      }
    });
  }

  void getAllMarkerPlaces() async {
    RequestResult result = await SpotController().getAll();
    if (result.ok) {
      setState(() {
        wildSpot.clear();
        campsite.clear();
        rvPark.clear();
        parking.clear();
        list.clear();
        spotMap.clear();
        this.orginalMarkers.clear();

        for (SpotModel spotModel in result.data) {
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
                  markerId:
                      MarkerId("${latlng.hashCode}_rv@${spotModel.spotId}"),
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
                  clusteringHelper.onCameraMove(newPosition,
                      forceUpdate: false);
                },
                onCameraIdle: clusteringHelper.onMapIdle,
                markers: markers,
              ),
              Positioned(
                width: sysWidth - 20,
                top: 10,
                left: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.bars,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          widget.drawerKey.currentState.openDrawer();
                        }),
                    Column(
                      children: <Widget>[
                        Text("NearBy", style: TextStyle(color: Colors.black)),
                        Text("$_nearestPlaces SPOTS AROUND YOU",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.filter,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _filterScreenVisibility = true;
                          });
                        }),
                  ],
                ),
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
                                zoom: 15)));
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
                                            onPressed: null,
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
              Positioned(
                top: 0,
                left: 0,
                child: Visibility(
                  visible: _filterScreenVisibility,
                  child: Container(
                    width: sysWidth,
                    height: sysHeight,
                    color: Resources.mainWhiteColor,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: sysHeight * 0.1,
                            width: sysWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Resources.mainBlackColor),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _filterScreenVisibility = false;
                                    });
                                  },
                                ),
                                Text(
                                  "Filter",
                                  style: TextStyle(
                                      color: Resources.mainBlackColor),
                                ),
                                GestureDetector(
                                  child: Text(
                                    "SAVE",
                                    style:
                                        TextStyle(color: Resources.mainColor),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      filterSpot(true);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "How far from my Location",
                            style: TextStyle(color: Resources.mainBlackColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        color: Resources.mainBlackColor),
                                  ),
                                  Text(
                                    "300 KM",
                                    style: TextStyle(
                                        color: Resources.mainBlackColor),
                                  ),
                                ],
                              ),
                              Container(
                                child: Slider(
                                    divisions: 300,
                                    min: 0,
                                    max: 300,
                                    label: "$_filterSliderVal KM",
                                    value: _filterSliderVal,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterSliderVal = value;
                                      });
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "SPOT TYPE",
                            style: TextStyle(color: Resources.mainBlackColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: sysWidth * 0.5 - 10,
                                  child: Row(
                                    children: <Widget>[
                                      AIconButtons(
                                        show,
                                        actImageUrl:
                                            "assets/icons/wild_spot_active.png",
                                        inactImageUrl:
                                            "assets/icons/wlid_spot_inactive.png",
                                        onTap: (status) {
                                          print(status);
                                          if (status) {
                                            if (!_filterSpotTypes.contains(
                                                Resources.spotType[0])) {
                                              _filterSpotTypes
                                                  .add(Resources.spotType[0]);
                                            }
                                          } else {
                                            if (_filterSpotTypes.contains(
                                                Resources.spotType[0])) {
                                              _filterSpotTypes.remove(
                                                  Resources.spotType[0]);
                                            }
                                          }
                                        },
                                        initAct: false,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Wild Spot",
                                        style: TextStyle(
                                            color: Resources.mainBlackColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: sysWidth * 0.5 - 10,
                                  child: Row(
                                    children: <Widget>[
                                      AIconButtons(
                                        show,
                                        actImageUrl:
                                            "assets/icons/park_act.png",
                                        inactImageUrl:
                                            "assets/icons/park_inact.png",
                                        onTap: (status) {
                                          print(status);
                                          if (status) {
                                            if (!_filterSpotTypes.contains(
                                                Resources.spotType[3])) {
                                              _filterSpotTypes
                                                  .add(Resources.spotType[3]);
                                            }
                                          } else {
                                            if (_filterSpotTypes.contains(
                                                Resources.spotType[3])) {
                                              _filterSpotTypes.remove(
                                                  Resources.spotType[3]);
                                            }
                                          }
                                        },
                                        initAct: false,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Parking",
                                        style: TextStyle(
                                            color: Resources.mainBlackColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: sysWidth * 0.5 - 10,
                                  child: Row(
                                    children: <Widget>[
                                      AIconButtons(
                                        show,
                                        actImageUrl:
                                            "assets/icons/campsite_act.png",
                                        inactImageUrl:
                                            "assets/icons/campsite_inact.png",
                                        onTap: (status) {
                                          print(status);
                                          if (status) {
                                            if (!_filterSpotTypes.contains(
                                                Resources.spotType[1])) {
                                              _filterSpotTypes
                                                  .add(Resources.spotType[1]);
                                            }
                                          } else {
                                            if (_filterSpotTypes.contains(
                                                Resources.spotType[1])) {
                                              _filterSpotTypes.remove(
                                                  Resources.spotType[1]);
                                            }
                                          }
                                        },
                                        initAct: false,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Campsite",
                                        style: TextStyle(
                                            color: Resources.mainBlackColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: sysWidth * 0.5 - 10,
                                  child: Row(
                                    children: <Widget>[
                                      AIconButtons(
                                        show,
                                        actImageUrl:
                                            "assets/icons/Rv_park_act.png",
                                        inactImageUrl:
                                            "assets/icons/Rv_park_inact.png",
                                        onTap: (status) {
                                          print(status);
                                          if (status) {
                                            if (!_filterSpotTypes.contains(
                                                Resources.spotType[2])) {
                                              _filterSpotTypes
                                                  .add(Resources.spotType[2]);
                                            }
                                          } else {
                                            if (_filterSpotTypes.contains(
                                                Resources.spotType[2])) {
                                              _filterSpotTypes.remove(
                                                  Resources.spotType[2]);
                                            }
                                          }
                                        },
                                        initAct: false,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "RV-Parking",
                                        style: TextStyle(
                                            color: Resources.mainBlackColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SpotDetails(
                            filter: true,
                            spotModel: _filterSpotModel,
                            show: show,
                            onSpotChange: (spotModel) {
                              setState(() {
                                _filterSpotModel = spotModel;
                              });
                            },
                          ),
                          SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
