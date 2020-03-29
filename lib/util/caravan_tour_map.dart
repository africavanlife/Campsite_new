import 'dart:async';

import 'package:campsite/controller/spot_controller.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/resources.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CaravanTourMapWidget extends StatefulWidget {
  @override
  _CaravanTourMapWidgetState createState() => _CaravanTourMapWidgetState();
}

class _CaravanTourMapWidgetState extends State<CaravanTourMapWidget> {
  Color layerIconColor = Colors.black;
  Color positionIconColor = Colors.black;
  MapType mapType = MapType.normal;
  // String mark = "";
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  List<LatLng> list = List();
  GoogleMapController _googleMapController;

  Position positionCur = Position(latitude: 0, longitude: 0);

  void _onMapCreated(GoogleMapController mapController) async {
    positionCur = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // print(position.latitude);

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(positionCur.latitude, positionCur.longitude),
        zoom: 15)));

    // _markers[MarkerId("currMark")] = (Marker(
    //   markerId: MarkerId("currMark"),
    //   position: LatLng(positionCur.latitude, positionCur.longitude),
    //   icon: Resources.currLocIconS,
    //   onTap: () {},
    // ));

    setState(() {});
    print("onMapCreated");
    _googleMapController = mapController;
  }

  BitmapDescriptor wildSpotIcon;
  BitmapDescriptor parkingIcon;
  BitmapDescriptor campsiteIcon;
  BitmapDescriptor rvParkIcon;
  BitmapDescriptor currLocIcon;

  List<LatLng> wildSpot = List();
  List<LatLng> parking = List();
  List<LatLng> campsite = List();
  List<LatLng> rvPark = List();
  bool _progressBarActive = true;
  void getAllMarkerPlaces() async {
    RequestResult result = await SpotController().getAll();
    if (result.ok) {
      setState(() {
        wildSpot.clear();
        campsite.clear();
        rvPark.clear();
        parking.clear();
        list.clear();

        for (SpotModel spotModel in result.data) {
          LatLng latlng = LatLng(spotModel.location.coordinates[1],
              spotModel.location.coordinates[0]);

          if (spotModel.spotType.toString() == Resources.spotType[0]) {
            _markers[MarkerId("${latlng.hashCode}")] = (Marker(
              markerId: MarkerId(
                  "${latlng.latitude},${latlng.longitude}@${spotModel.spotId}"),
              position: latlng,
              icon: Resources.wildSpotIconS,
              onTap: () {
                setState(() {
                  Navigator.pop(context,
                      "${latlng.latitude},${latlng.longitude}@${spotModel.spotId}");
                });
              },
            ));

            wildSpot.add(latlng);
          }

          if (spotModel.spotType.toString() == Resources.spotType[1]) {
            _markers[MarkerId("${latlng.hashCode}")] = (Marker(
              markerId: MarkerId(
                  "${latlng.latitude},${latlng.longitude}@${spotModel.spotId}"),
              position: latlng,
              icon: Resources.campsiteIconS,
              onTap: () {
                setState(() {
                  Navigator.pop(context,
                      "${latlng.latitude},${latlng.longitude}@${spotModel.spotId}");
                });
              },
            ));

            campsite.add(latlng);
          }

          if (spotModel.spotType.toString() == Resources.spotType[2]) {
            _markers[MarkerId("${latlng.hashCode}")] = (Marker(
              markerId: MarkerId(
                  "${latlng.latitude},${latlng.longitude}@${spotModel.spotId}"),
              position: latlng,
              icon: Resources.rvParkIconS,
              onTap: () {
                setState(() {
                  Navigator.pop(context,
                      "${latlng.latitude},${latlng.longitude}@${spotModel.spotId}");
                });
              },
            ));

            rvPark.add(latlng);
          }

          if (spotModel.spotType.toString() == Resources.spotType[3]) {
            _markers[MarkerId("${latlng.hashCode}")] = (Marker(
              markerId: MarkerId(
                  "${latlng.latitude},${latlng.longitude}@${spotModel.spotId}"),
              position: latlng,
              icon: Resources.parkingIconS,
              onTap: () {
                setState(() {
                  Navigator.pop(context,
                      "${latlng.latitude},${latlng.longitude}@${spotModel.spotId}");
                });
              },
            ));

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
  void initState() {
    setIcons();
    getAllMarkerPlaces();
    // for (LatLng latlng in wildSpot) {
    //   _markers[MarkerId("${latlng.hashCode}")] = (Marker(
    //     markerId: MarkerId("${latlng.hashCode}"),
    //     position: latlng,
    //     icon: Resources.wildSpotIconS,
    //     onTap: () {
    //       setState(() {
    //         Navigator.pop(context, "${latlng.latitude},${latlng.longitude}");
    //       });
    //     },
    //   ));
    // }
    // for (LatLng latlng in parking) {
    //   _markers[MarkerId("${latlng.hashCode}")] = (Marker(
    //     markerId: MarkerId("${latlng.hashCode}"),
    //     position: latlng,
    //     icon: Resources.parkingIconS,
    //     onTap: () {
    //       setState(() {
    //         Navigator.pop(context, "${latlng.latitude},${latlng.longitude}");
    //       });
    //     },
    //   ));
    // }

    // for (LatLng latlng in campsite) {
    //   _markers[MarkerId("${latlng.hashCode}")] = (Marker(
    //     markerId: MarkerId("${latlng.hashCode}"),
    //     position: latlng,
    //     icon: Resources.campsiteIconS,
    //     onTap: () {
    //       setState(() {
    //         Navigator.pop(context, "${latlng.latitude},${latlng.longitude}");
    //       });
    //     },
    //   ));
    // }

    // for (LatLng latlng in rvPark) {
    //   _markers[MarkerId("${latlng.hashCode}")] = (Marker(
    //     markerId: MarkerId("${latlng.hashCode}"),
    //     position: latlng,
    //     icon: Resources.rvParkIconS,
    //     onTap: () {
    //       setState(() {
    //         Navigator.pop(context, "${latlng.latitude},${latlng.longitude}");
    //       });
    //     },
    //   ));
    // }

    super.initState();
  }

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
                mapType: mapType,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: _onMapCreated,
                markers: Set<Marker>.of(_markers.values),
                onCameraMove: (position) {
                  setState(() {
                    positionIconColor=Colors.black;
                  });
                },
              ),
              Positioned(
                bottom: 60,
                right: 10,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
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
                          // print("AAAAAAAAAAAA");
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
                        icon: Icon(
                          FontAwesomeIcons.crosshairs,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
