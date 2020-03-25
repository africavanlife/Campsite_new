import 'dart:async';

import 'package:campsite/screens/event_add_spot_map.dart';
import 'package:campsite/util/caravan_tour_map.dart';
import 'package:campsite/util/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OtherEventsWidget extends StatefulWidget {
  OtherEventsWidget({this.onSelected});
  Function(List spots) onSelected;
  @override
  _OtherEventsWidgetState createState() => _OtherEventsWidgetState();
}

class _OtherEventsWidgetState extends State<OtherEventsWidget> {
  Completer<GoogleMapController> _controller = Completer();
  List<String> eventSpotID = List();
  List<String> eventPlace = List();
  Color layerIconColor = Colors.black;
  Color positionIconColor = Colors.black;
  MapType mapType = MapType.normal;
  // String mark = "";
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  // Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  // List<LatLng> list = List();

  @override
  void initState() {
    // list.add((LatLng(37.42796133580664, -121.085749655962)));
    // list.add((LatLng(37.45796133580664, -122.060749655962)));
    // list.add((LatLng(37.50796133580664, -122.105749655962)));
    // list.add((LatLng(37.60096133580664, -122.200749655962)));
    // list.add((LatLng(38.42796133580664, -122.285749655962)));
    // list.add((LatLng(37.70796133580664, -122.785749655962)));

    // list.add((LatLng(57.42796133580664, -101.085749655962)));
    // list.add((LatLng(57.45796133580664, -102.060749655962)));
    // list.add((LatLng(57.50796133580664, -102.105749655962)));
    // list.add((LatLng(57.60096133580664, -102.200749655962)));
    // list.add((LatLng(58.42796133580664, -102.285749655962)));
    // list.add((LatLng(57.70796133580664, -102.785749655962)));

    // for (int i = 0; i < list.length; i++) {
    //   _markers[MarkerId("$i")] = Marker(
    //     markerId: MarkerId("$i"),
    //     position: list[i],
    //     onTap: () {
    //       setState(() {
    //         Navigator.pop(context, "${list[i].latitude},${list[i].longitude}");
    //       });
    //     },
    //   );
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.grey,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Select Exit Spot in the Map or "),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: sysHeight * 0.02,
                    width: sysHeight * 0.15,
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      buttonColor: Colors.transparent,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        onPressed: () async {
                          String txt = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventAddNewSpotMap()));
                          // String txt =
                          //     await (Resources.navigationKey.currentState)
                          //         .pushNamed("/eventAddSpotMap");
                          print(txt);
                          setState(() {
                            // eventPlace[0] = txt.split("@")[0];
                            // eventSpotID[0] = txt.split("@")[1];

                            if (eventPlace.length > 0) {
                              eventPlace[0] = txt.split("@")[0];
                              eventSpotID[0] = txt.split("@")[1];
                            } else {
                              eventPlace.add(txt.split("@")[0]);
                              eventSpotID.add(txt.split("@")[1]);
                            }
                            widget.onSelected(eventSpotID);
                          });
                        },
                        child: Text(
                          "ADD SPOT",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: sysWidth,
                height: sysHeight * 0.5,
                child: GestureDetector(
                  onTap: () async {
                    print("CLICKED");
                    String txt = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CaravanTourMapWidget()));
                    print(txt);
                    setState(() {
                      if (eventPlace.length > 0) {
                        eventPlace[0] = txt.split("@")[0];
                        eventSpotID[0] = txt.split("@")[1];
                      } else {
                        eventPlace.add(txt.split("@")[0]);
                        eventSpotID.add(txt.split("@")[1]);
                      }
                      widget.onSelected(eventSpotID);
                    });
                  },
                  // child: GoogleMap(
                  //   mapType: mapType,
                  //   initialCameraPosition: _kGooglePlex,
                  //   onMapCreated: (GoogleMapController controller) {
                  //     _controller.complete(controller);
                  //   },
                  //   // markers: Set<Marker>.of(_markers.values),
                  // ),
                  child: Image(
                    image: AssetImage("assets/mapImage.png"),
                    width: sysWidth,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
