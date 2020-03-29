import 'dart:async';

import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:campsite/controller/event_controller.dart';
import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/controller/spot_controller.dart';
import 'package:campsite/model/event.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/icon_buttons.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/util/spot_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommunityScreen extends StatefulWidget {
  CommunityScreen(this.drawerKey);
  final drawerKey;
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _progressBarActive = true;
  Color layerIconColor = Colors.black;
  Color positionIconColor = Colors.black;
  MapType mapType = MapType.normal;
  EventModel _selectedEvent = EventModel();
  bool _markerDetailVisibility = false;
  bool _filterScreenVisibility = false;
  int _filterSliderVal = 0;
  List<String> _filterTypeList = List();
  bool show = false;
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GoogleMapController _googleMapController;

  List<List<LatLng>> caravanToursList = List();
  List<LatLng> cleanUpList = List();
  List<LatLng> meatupList = List();
  List<Polyline> polylines = List();
  Set<Marker> markers = Set();
  Position positionCur;
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
  }

  @override
  void initState() {
    super.initState();
    setIcons();
    setMarkers(false);
  }

  BitmapDescriptor caravanTourIcon;
  BitmapDescriptor cleanupIcon;
  BitmapDescriptor meetupIcon;
  BitmapDescriptor currLocIcon;

  setIcons() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/caravantours.png')
        .then((caravanTourIcon) {
      this.caravanTourIcon = caravanTourIcon;
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(), 'assets/cleanup.png')
          .then((cleanupIcon) {
        this.cleanupIcon = cleanupIcon;
        BitmapDescriptor.fromAssetImage(
                ImageConfiguration(), 'assets/meetup.png')
            .then((meetupIcon) {
          this.meetupIcon = meetupIcon;
          BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(), 'assets/curLoc.bmp')
              .then((currLocIcon) {
            this.currLocIcon = currLocIcon;
            setState(() {
              setMarkers(false);
            });
          });
        });
      });
    });
    setState(() {});
  }

  setMarkers(bool isFilter) async {
    RequestResult value = isFilter
        ? await EventController()
            .filterByEvent(_filterTypeList, _filterSliderVal)
        : await EventController().getAll();

    setState(() {
      _progressBarActive = true;
      caravanToursList.clear();
      cleanUpList.clear();
      meatupList.clear();
      polylines.clear();
      markers.clear();
    });

    if (isFilter) {
      // markers.add(Marker(
      //   markerId: MarkerId("currMark"),
      //   position: LatLng(positionCur.latitude, positionCur.longitude),
      //   icon: currLocIcon,
      //   onTap: () {},
      // ));
    }

    print("OOOOOOOOOOOOOOOOOOOO    : " + value.data.length.toString());

    if (value.ok) {
      caravanToursList = List();
      cleanUpList = List();
      meatupList = List();
      polylines = List();
      markers = Set();

      for (EventModel _evntMdl in value.data) {
        if (_evntMdl.eventType == Resources.eventType[0]) {
          // for (String spotId in _evntMdl.spotID) {
          RequestResult _req =
              await SpotController().getById(_evntMdl.spotID[0]);
          if (_req.ok) {
            SpotModel _spotModel = _req.data[0];
            LatLng latLng = LatLng(_spotModel.location.coordinates[1],
                _spotModel.location.coordinates[0]);
            markers.add(Marker(
              markerId: MarkerId(_spotModel.spotId + "@" + _evntMdl.id),
              position: latLng,
              onTap: () {
                setState(() {
                  _selectedEvent = _evntMdl;
                  _markerDetailVisibility = true;
                  getStartAddress(_spotModel.spotId);
                });
              },
              icon: this.meetupIcon,
            ));
            meatupList.add(latLng);
          }
          // }
        }

        if (_evntMdl.eventType == Resources.eventType[1]) {
          // for (String spotId in _evntMdl.spotID) {
          RequestResult _req =
              await SpotController().getById(_evntMdl.spotID[1]);
          if (_req.ok) {
            SpotModel _spotModel = _req.data[0];
            LatLng latLng = LatLng(_spotModel.location.coordinates[1],
                _spotModel.location.coordinates[0]);
            markers.add(Marker(
              markerId: MarkerId(_spotModel.spotId + "@" + _evntMdl.id),
              position: latLng,
              onTap: () {
                setState(() {
                  _selectedEvent = _evntMdl;
                  _markerDetailVisibility = true;
                  getStartAddress(_spotModel.spotId);
                });
              },
              icon: this.cleanupIcon,
            ));
            cleanUpList.add(latLng);
          }
          // }
        }

        if (_evntMdl.eventType == Resources.eventType[2]) {
          List<SpotModel> spots = List();
          if (_evntMdl.spotID.length < 4) {
            List<LatLng> lst = List();

            for (String spotId in _evntMdl.spotID) {
              // RequestResult _req = await SpotController().getById(spotId);
              List<String> ltlng = spotId.split(",");
              // if (_req.ok) {
              // SpotModel _spotModel = _req.data[0];
              // spots.add(_spotModel);
              LatLng latLng =
                  LatLng(double.parse(ltlng[0]), double.parse(ltlng[1]));
              markers.add(Marker(
                markerId:
                    MarkerId(latLng.hashCode.toString() + "@" + _evntMdl.id),
                position: latLng,
                onTap: () {
                  setState(() {
                    _selectedEvent = _evntMdl;
                    _markerDetailVisibility = true;
                  });
                },
                icon: this.caravanTourIcon,
              ));
              lst.add(latLng);
              // }
            }
            caravanToursList.add(lst);
          } else {
            List<LatLng> lst = List();
            for (var i = 0; i < 3; i++) {
              // RequestResult _req =
              //     await SpotController().getById(_evntMdl.spotID[i]);
              // if (_req.ok) {
              // SpotModel _spotModel = _req.data[0];
              // spots.add(_spotModel);
              List<String> ltlng = _evntMdl.spotID[i].split(",");
              LatLng latLng =
                  LatLng(double.parse(ltlng[0]), double.parse(ltlng[1]));
              markers.add(Marker(
                markerId:
                    MarkerId(latLng.hashCode.toString() + "@" + _evntMdl.id),
                position: latLng,
                onTap: () {
                  setState(() {
                    _selectedEvent = _evntMdl;
                    _markerDetailVisibility = true;
                  });
                },
                icon: this.caravanTourIcon,
              ));
              lst.add(latLng);
              // }
            }
            caravanToursList.add(lst);
          }
        }
      }
    }

    for (List<LatLng> lst in caravanToursList) {
      List<LatLng> poliList = List();
      PolylinePoints polylinePoints = PolylinePoints();
      for (var p = 1; p < lst.length; p++) {
        List<PointLatLng> result =
            await polylinePoints.getRouteBetweenCoordinates(
                Resources.googleAPIKey,
                lst[p - 1].latitude,
                lst[p - 1].longitude,
                lst[p].latitude,
                lst[p].longitude);

        result.forEach((element) {
          poliList.add(LatLng(element.latitude, element.longitude));
        });
      }

      Polyline polyline = Polyline(
        color: Color.fromRGBO(255, 0, 0, 0.5),
        polylineId: PolylineId(lst.hashCode.toString()),
        width: 5,
        points: poliList,
        visible: true,
      );
      polylines.add(polyline);
    }
    print("LOADED");

    setState(() {
      _progressBarActive = false;
      caravanToursList = caravanToursList;
      cleanUpList = cleanUpList;
      meatupList = meatupList;
      polylines = polylines;
      markers = markers;
    });
  }

  String _startingAddress = "";
  String _endAddress = "";

  getStartAddress(String spotID) async {
    RequestResult _req = await SpotController().getById(spotID);
    SpotModel _spot = _req.data[0];
    final coordinates = new Coordinates(
        _spot.location.coordinates[1], _spot.location.coordinates[0]);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first.c;
    // Address
    setState(() {
      _startingAddress = addresses.first.locality;
    });

    // return addresses.first.locality.toString();
  }

  getEndAddress(String spotID) async {
    RequestResult _req = await SpotController().getById(spotID);
    SpotModel _spot = _req.data[0];
    final coordinates = new Coordinates(
        _spot.location.coordinates[1], _spot.location.coordinates[0]);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first.c;
    // Address
    setState(() {
      _endAddress = addresses.first.locality;
    });

    // return addresses.first.locality.toString();
  }

  ProfileModel _profile = ProfileModel();
  getUser(String userID) async {
    RequestResult _req = await ProfileController().getById(userID);
    _profile = _req.data.first;
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
                onMapCreated: _onMapCreated,
                mapType: mapType,
                initialCameraPosition: _kGooglePlex,
                markers: markers,
                polylines: polylines.toSet(),
                onCameraMove: (position) {
                  setState(() {
                    positionIconColor = Colors.black;
                  });
                },
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
                    Text(
                      "EVENTS",
                      style: TextStyle(color: Colors.black),
                    ),
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.filter,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          print("object");
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
                        Position position = await Geolocator()
                            .getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high);
                        print(position.latitude);

                        _googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(
                                    position.latitude, position.longitude),
                                zoom: 15)));
                        setState(() {
                          positionIconColor = Colors.red;
                        });
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
                    child: GestureDetector(
                      onTap: () {
                        print("CLICKED");
                        Resources.navigationKey.currentState.pushNamed(
                            '/communityDetails',
                            arguments: _selectedEvent);
                      },
                      child: Container(
                        width: sysWidth - 20,
                        // height: sysHeight * 0.4,
                        color: Resources.mainWhiteColor,
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                _selectedEvent.images == ""
                                    ? Container()
                                    : Image(
                                        width: (sysWidth - 20),
                                        height: sysHeight * 0.3,
                                        fit: BoxFit.cover,
                                        image:
                                            NetworkImage(_selectedEvent.images),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      _selectedEvent.eventType == null
                                          ? Container()
                                          : _selectedEvent.eventType ==
                                                  Resources.eventType[2]
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      // "Starting : ${_selectedEvent.spotID == null ? "" : _selectedEvent.spotID.length < 1 ? "" : getAddress(_selectedEvent.spotID[0]).then((value) => value)}",
                                                      "Starting : ${_selectedEvent.spotID.length < 1 ? "" : _selectedEvent.spotID[0]}",
                                                      style: TextStyle(
                                                          color: Resources
                                                              .mainBlackColor),
                                                    ),
                                                    Text(
                                                      "|",
                                                      style: TextStyle(
                                                          color: Resources
                                                              .mainBlackColor),
                                                    ),
                                                    Text(
                                                      // "Ending : ${_selectedEvent.spotID == null ? "" : _selectedEvent.spotID.length < 1 ? "" : getAddress(_selectedEvent.spotID[_selectedEvent.spotID.length - 1])}",
                                                      "Ending : ${_selectedEvent.spotID.length < 1 ? "" : _selectedEvent.spotID[_selectedEvent.spotID.length - 1]}",
                                                      style: TextStyle(
                                                          color: Resources
                                                              .mainBlackColor),
                                                    )
                                                  ],
                                                )
                                              : Text(
                                                  "City : ${_startingAddress == null ? "" : _startingAddress}",
                                                  // "City : ${_selectedEvent.spotID == null ? "" : _selectedEvent.spotID.length < 1 ? "" : getAddress(_selectedEvent.spotID[0]).then((value) => value)}",
                                                  style: TextStyle(
                                                      color: Resources
                                                          .mainBlackColor),
                                                ),
                                      Row(
                                        children: <Widget>[
                                          _profile.profPic == null
                                              ? Container()
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      _profile.profPic),
                                                  radius: 20,
                                                ),
                                          Text(
                                            _profile.profileName == null
                                                ? ""
                                                : _profile.profileName,
                                            style: TextStyle(
                                                color:
                                                    Resources.mainBlackColor),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        FontAwesomeIcons.crosshairs,
                                        color: Resources.mainBlackColor,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Positioned(
                              child: AIconButtons(
                                show,
                                actImageUrl: "assets/like_act.png",
                                inactImageUrl: "assets/like_inactv.png",
                                onTap: (status) {
                                  print(status);
                                },
                                initAct: false,
                              ),
                              top: 50,
                              right: 10,
                            ),
                            Positioned(
                                top: sysHeight * 0.2,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: (sysWidth - 40),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            _selectedEvent.about == null
                                                ? ""
                                                : _selectedEvent.about,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Flexible(
                                            child: Text(
                                          _selectedEvent.eventType == null
                                              ? ""
                                              : _selectedEvent.eventType,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ],
                                    ),
                                  ),
                                )),
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
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Visibility(
                  visible: _filterScreenVisibility,
                  child: Container(
                    width: sysWidth,
                    height: sysHeight * 0.8,
                    color: Resources.mainWhiteColor,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            color: Resources.mainWhiteColor,
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
                                    setMarkers(true);
                                    setState(() {
                                      _filterScreenVisibility = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          // TextField(
                          //   decoration: InputDecoration(labelText: "SEARCH"),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Text("TIMELINE"),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Past Year"),
                                  Text("Now"),
                                  Text("Next Year")
                                ],
                              ),
                              Container(
                                child: Slider(
                                    divisions: 24,
                                    min: -12,
                                    max: 12,
                                    label: _filterSliderVal == 0
                                        ? "NOW"
                                        : "${_filterSliderVal.abs()} Months ${_filterSliderVal > 0 ? 'Next' : 'Ago'}",
                                    value: _filterSliderVal.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        _filterSliderVal = value.toInt();
                                      });
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Event Catagories"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                CheckBoxTile(
                                  show,
                                  title: "Campsite Cleanup",
                                  value: _filterTypeList
                                            .contains(Resources.eventType[1]),
                                  width: sysWidth,
                                  onChange: (value) {
                                    setState(() {
                                      if (value) {
                                        if (!_filterTypeList
                                            .contains(Resources.eventType[1])) {
                                          _filterTypeList
                                              .add(Resources.eventType[1]);
                                        }
                                      } else {
                                        if (_filterTypeList
                                            .contains(Resources.eventType[1])) {
                                          _filterTypeList
                                              .remove(Resources.eventType[1]);
                                        }
                                      }
                                    });
                                    print(_filterTypeList.toString());
                                  },
                                ),
                                CheckBoxTile(
                                  show,
                                  title: "Caravan Tours",
                                  value: _filterTypeList
                                            .contains(Resources.eventType[2]),
                                  width: sysWidth,
                                  onChange: (value) {
                                    setState(() {
                                      if (value) {
                                        if (!_filterTypeList
                                            .contains(Resources.eventType[2])) {
                                          _filterTypeList
                                              .add(Resources.eventType[2]);
                                        }
                                      } else {
                                        if (_filterTypeList
                                            .contains(Resources.eventType[2])) {
                                          _filterTypeList
                                              .remove(Resources.eventType[2]);
                                        }
                                      }
                                    });
                                    print(_filterTypeList);
                                  },
                                ),
                                CheckBoxTile(
                                  show,
                                  title: "Meetup",
                                  value: _filterTypeList
                                            .contains(Resources.eventType[0]),
                                  width: sysWidth,
                                  onChange: (value) {
                                    setState(() {
                                      if (value) {
                                        if (!_filterTypeList
                                            .contains(Resources.eventType[0])) {
                                          _filterTypeList
                                              .add(Resources.eventType[0]);
                                        }
                                      } else {
                                        if (_filterTypeList
                                            .contains(Resources.eventType[0])) {
                                          _filterTypeList
                                              .remove(Resources.eventType[0]);
                                        }
                                      }
                                    });
                                    print(_filterTypeList);
                                  },
                                ),
                              ],
                            ),
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

//  final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
