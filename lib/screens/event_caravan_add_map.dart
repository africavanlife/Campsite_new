import 'dart:async';
import 'dart:typed_data';

import 'package:campsite/controller/image_controller.dart';
import 'package:campsite/model/location.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/model/accessibility.dart';
import 'package:campsite/model/environment.dart';
import 'package:campsite/model/necessities.dart';
import 'package:campsite/model/activities.dart';
// import 'package:campsite/screens/add_new_spot_fill.dart';
import 'package:campsite/util/resources.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EventCaravanAddMap extends StatefulWidget {
  @override
  _EventCaravanAddMapState createState() => _EventCaravanAddMapState();
}

class _EventCaravanAddMapState extends State<EventCaravanAddMap> {
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
                 Navigator.pop(context,"${_markers[MarkerId('1')].position.latitude},${_markers[MarkerId('1')].position.longitude}" );
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
    print("onMapCreated");
    positionCur = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(positionCur.latitude, positionCur.longitude),
        zoom: 15)));

    _markers[MarkerId("currMark")] = Marker(
      markerId: MarkerId("currMark"),
      position: LatLng(positionCur.latitude, positionCur.longitude),
      icon: Resources.currLocIconS,
      onTap: () {},
    );

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
        ),],
    );
  }
}
