import 'dart:async';

import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:campsite/model/accessibility.dart';
import 'package:campsite/model/activities.dart';
import 'package:campsite/model/environment.dart';
import 'package:campsite/model/necessities.dart';
import 'package:campsite/model/spot.dart';
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

class ProfileMap extends StatefulWidget {
  ProfileMap(
      {@required this.campsite,
      @required this.parking,
      @required this.rvPark,
      @required this.wildSpot});
  final List<LatLng> wildSpot;
  final List<LatLng> parking;
  final List<LatLng> campsite;
  final List<LatLng> rvPark;
  @override
  _ProfileMapState createState() => _ProfileMapState();
}

class _ProfileMapState extends State<ProfileMap> {
  SpotModel _filterSpotModel = SpotModel();
  AccessibilityModel _accessibilityModel = AccessibilityModel();
  ActivitiesModel _activitiesModel = ActivitiesModel();
  EnvironmentModel _environmentModel = EnvironmentModel();
  NecessitiesModel _necessitiesModel = NecessitiesModel();
  Color layerIconColor = Colors.black;
  Color positionIconColor = Colors.black;
  MapType mapType = MapType.normal;
  
  bool _markerDetailVisibility = false;
  bool _filterScreenVisibility = false;
  double _filterSliderVal = 170;
  bool show = false;
  GoogleMapController _googleMapController;

  Set<Marker> markers = Set();

  void _onMapCreated(GoogleMapController mapController) async {
    setState(() {});
    print("onMapCreated");
    _googleMapController = mapController;
  }


  @override
  void initState() {
    _filterSpotModel.accessibility = _accessibilityModel;
    _filterSpotModel.activities = _activitiesModel;
    _filterSpotModel.necessities = _necessitiesModel;
    _filterSpotModel.environment = _environmentModel;
    for (LatLng latlng in widget.wildSpot) {
      markers.add(Marker(
        markerId: MarkerId("${latlng.hashCode}_wild"),
        position: latlng,
        icon: Resources.wildSpotIconS,
        onTap: () {
          setState(() {
            _markerDetailVisibility = true;
          });
        },
      ));
    }
    for (LatLng latlng in widget.parking) {
      markers.add(Marker(
        markerId: MarkerId("${latlng.hashCode}_park"),
        position: latlng,
        icon: Resources.parkingIconS,
        onTap: () {
          setState(() {
            _markerDetailVisibility = true;
          });
        },
      ));
    }

    for (LatLng latlng in widget.campsite) {
      markers.add(Marker(
        markerId: MarkerId("${latlng.hashCode}_camp"),
        position: latlng,
        icon: Resources.campsiteIconS,
        onTap: () {
          setState(() {
            _markerDetailVisibility = true;
          });
        },
      ));
    }

    for (LatLng latlng in widget.rvPark) {
      markers.add(Marker(
        markerId: MarkerId("${latlng.hashCode}_rv"),
        position: latlng,
        icon: Resources.rvParkIconS,
        onTap: () {
          setState(() {
            _markerDetailVisibility = true;
          });
        },
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: mapType,
          initialCameraPosition: CameraPosition(
            target: widget.wildSpot.first,
            zoom: 14.4746,
          ),
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text("CANCEL"),
              ),
              Column(
                children: <Widget>[
                  Text("MY LOCATIONS : 10"),
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
                onPressed: () async {
                  Position position = await Geolocator().getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  print(position.latitude);

                  _googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 15)));
                },
                icon: Icon(
                  FontAwesomeIcons.crosshairs,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
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
                  child: Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image(
                            width: (sysWidth - 20) * 0.85,
                            height: sysHeight * 0.3,
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              AIconButtons(
                                false,
                                actImageUrl: "assets/like_act.png",
                                inactImageUrl: "assets/like_inactv.png",
                                onTap: (value) {},
                              ),
                              // IconButton(
                              //   icon: ImageIcon(
                              //     AssetImage("assets/like_act.png"),
                              //   ),
                              //   onPressed: null,
                              // ),
                              IconButton(
                                  icon: ImageIcon(
                                    AssetImage("assets/profile.png"),
                                  ),
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             SpotScreen()));
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
                        right: -10,
                        top: -10,
                        child: IconButton(
                          icon: Icon(FontAwesomeIcons.timesCircle,
                              color: Colors.red),
                          onPressed: () {
                            setState(
                              () {
                                _markerDetailVisibility = false;
                              },
                            );
                          },
                        ),
                      )
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
                              style: TextStyle(color: Resources.mainBlackColor),
                            ),
                            onTap: () {
                              setState(() {
                                _filterScreenVisibility = false;
                              });
                            },
                          ),
                          Text(
                            "Filter",
                            style: TextStyle(color: Resources.mainBlackColor),
                          ),
                          GestureDetector(
                            child: Text(
                              "SAVE",
                              style: TextStyle(color: Resources.mainColor),
                            ),
                            onTap: () {
                              setState(() {
                                _filterScreenVisibility = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Text("How far from my Location"),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("0"),
                            Text("300 KM"),
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
                    Text("SPOT TYPE"),
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
                                  },
                                  initAct: false,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Wild Spot"),
                              ],
                            ),
                          ),
                          Container(
                            width: sysWidth * 0.5 - 10,
                            child: Row(
                              children: <Widget>[
                                AIconButtons(
                                  show,
                                  actImageUrl: "assets/icons/park_act.png",
                                  inactImageUrl: "assets/icons/park_inact.png",
                                  onTap: (status) {
                                    print(status);
                                  },
                                  initAct: true,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Parking"),
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
                                  actImageUrl: "assets/icons/campsite_act.png",
                                  inactImageUrl:
                                      "assets/icons/campsite_inact.png",
                                  onTap: (status) {
                                    print(status);
                                  },
                                  initAct: false,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Campsite"),
                              ],
                            ),
                          ),
                          Container(
                            width: sysWidth * 0.5 - 10,
                            child: Row(
                              children: <Widget>[
                                AIconButtons(
                                  show,
                                  actImageUrl: "assets/icons/Rv_park_act.png",
                                  inactImageUrl:
                                      "assets/icons/Rv_park_inact.png",
                                  onTap: (status) {
                                    print(status);
                                  },
                                  initAct: true,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("RV-Parking"),
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
                      filter:true,
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
