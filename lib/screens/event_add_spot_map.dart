import 'dart:async';
import 'dart:typed_data';

import 'package:campsite/model/location.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/model/accessibility.dart';
import 'package:campsite/model/environment.dart';
import 'package:campsite/model/necessities.dart';
import 'package:campsite/model/activities.dart';
import 'package:campsite/screens/event_add_spot_fill.dart';
import 'package:campsite/util/image_picker.dart';

import 'package:campsite/util/resources.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class EventAddNewSpotMap extends StatefulWidget {
  @override
  _EventAddNewSpotMapState createState() => _EventAddNewSpotMapState();
}

class _EventAddNewSpotMapState extends State<EventAddNewSpotMap> {
  MapType mapType = MapType.normal;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  bool _markerDetailVisibility = false;
  CameraPosition _kInitialLocation = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  GoogleMapController _googleMapController;

  // bool enableCarousal = false;
  BitmapDescriptor pinIcon;
  getLocation() async {
    pinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/select_location.png');
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(
      () {
        _markers[MarkerId("1")] = Marker(
            markerId: MarkerId("1"),
            position: LatLng(position.latitude, position.longitude),
            onTap: () {
              print("CLICKD");
              setState(() {
                _markerDetailVisibility = true;
              });
            },
            icon: pinIcon);
        print(position.longitude);

        _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18,
            ),
          ),
        );
      },
    );
  }
Position positionCur = Position(latitude: 0, longitude: 0);
  void _onMapCreated(GoogleMapController mapController) async {
      positionCur = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(positionCur.latitude, positionCur.longitude),
        zoom: 15)));

    //   _markers[MarkerId("currMark")] = Marker(
    //   markerId: MarkerId("currMark"),
    //   position: LatLng(positionCur.latitude, positionCur.longitude),
    //   icon: Resources.currLocIconS,
    //   onTap: () {},
    // );

    print("onMapCreated");
    _googleMapController = mapController;
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        GoogleMap(
           myLocationButtonEnabled: false,
                myLocationEnabled: true,
          mapType: mapType,
          initialCameraPosition: _kInitialLocation,
          onMapCreated: _onMapCreated,
          onCameraMove: (CameraPosition position) {
            if (_markers.length > 0) {
              Marker marker = _markers[MarkerId("1")];
              Marker updatedMarker = marker.copyWith(
                positionParam: position.target,
              );

              setState(() {
                _markers[MarkerId("1")] = updatedMarker;
              });
              print(position.target.toString());
            }
          },
          markers: Set<Marker>.of(_markers.values),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Visibility(
              visible: _markerDetailVisibility,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: sysWidth - 20,
                    // height: sysHeight * 0.3,
                    color: Resources.mainWhiteColor,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          // color: Colors.white38,
                          color: Resources.mainWhiteColor,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: _markers[MarkerId("1")] == null
                                ? Container()
                                : AddNewSpotForm(
                                    cordinates:
                                        _markers[MarkerId("1")].position,
                                  ),
                          ),
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
              ),
            )),
      ],
    );
  }
}

class AddNewSpotForm extends StatefulWidget {
  AddNewSpotForm({@required this.cordinates});
  final LatLng cordinates;

  @override
  _AddNewSpotFormState createState() => _AddNewSpotFormState();
}

class _AddNewSpotFormState extends State<AddNewSpotForm> {
  SpotModel _spotModel = SpotModel();

  TextEditingController _txtSpotName = TextEditingController();

  String _selectedSpotType;

  final _formKey = GlobalKey<FormState>();
  List<Uint8List> images = List<Uint8List>();

  AccessibilityModel _accessibilityModel = AccessibilityModel();
  ActivitiesModel _activitiesModel = ActivitiesModel();
  NecessitiesModel _necessitiesModel = NecessitiesModel();
  EnvironmentModel _environmentModel = EnvironmentModel();

  @override
  void initState() {
    setState(() {
      _spotModel.userID = Resources.userId;
      _spotModel.location = LocationModel(coordinates: [
        widget.cordinates.longitude,
        widget.cordinates.latitude
      ], type: "Point");
      _spotModel.accessibility = _accessibilityModel;
      _spotModel.activities = _activitiesModel;
      _spotModel.necessities = _necessitiesModel;
      _spotModel.environment = _environmentModel;
    });
    super.initState();
  }

  bool enableCorousal = false;
  List<String> _spotType = Resources.spotType;

  List<String> _imageTypes = List();

loadAssets(){
    ImagePickerClass(context, (img, imageTypes) {
      _imageTypes.addAll(imageTypes);
      images.addAll(img);
      setState(() {
          enableCorousal = images.length > 0;
      images = images;
      });
      // setPrint(images.length > 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height - 50;
    double sysWidth = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _txtSpotName,
              decoration: InputDecoration(labelText: "Give It a Name"),
              validator: (value) {
                if (value.isEmpty) {
                  // return 'Please enter some text';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
                value: _selectedSpotType,
                validator: (value) {
                  if (value == null) {
                    // return 'Please Select Category';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: "Traveller Status"),
                items: _spotType.map(
                  (category) {
                    return DropdownMenuItem(
                      child: Text(category),
                      value: category,
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpotType = value;
                  });
                  // widget.onChange(value);
                }),
            enableCorousal
                ? SizedBox(
                    width: sysWidth,
                    height: sysHeight * 0.3,
                    child: Carousel(
                      boxFit: BoxFit.cover,
                      autoplay: false,
                      animationCurve: Curves.fastOutSlowIn,
                      animationDuration: Duration(milliseconds: 1000),
                      dotSize: 6.0,
                      dotIncreasedColor: Colors.green,
                      dotBgColor: Colors.black38,
                      dotPosition: DotPosition.bottomCenter,
                      showIndicator: true,
                      indicatorBgPadding: 7.0,
                      images: [for (Uint8List img in images) MemoryImage(img)],
                    ),
                  )
                : GestureDetector(
                    child: Image(
                      image: AssetImage("assets/add_image.png"),
                      width: sysWidth,
                      height: sysHeight * 0.3,
                      fit: BoxFit.cover,
                    ),
                    onTap: () async {
                      setState(() {
                        // _spotModel.images = Resources.images;
                      });
                      loadAssets();
                    },
                  ),
            ButtonTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              buttonColor: Colors.red,
              minWidth: double.infinity,
              height: sysHeight * 0.05,
              child: RaisedButton(
                onPressed: () async {
                  setState(() {
                    _spotModel.name = _txtSpotName.text;
                    _spotModel.spotType = _selectedSpotType;
                  });

                  String txt = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventAddNewSpotFill(
                              _spotModel, images, _imageTypes)));
                  print("TEEEEEEEE   : " + txt);
                  Navigator.pop(context, txt);
                  // Resources.navigationKey.currentState
                  //     .pushReplacementNamed("/eventAddSpotFill", arguments:{'spotModel': _spotModel,'images':images,'imgTypes':_imageTypes});
                },
                child: Text(
                  "SAVE",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),
    );
  }
}
