import 'dart:io';
import 'dart:typed_data';

import 'package:campsite/controller/event_controller.dart';
import 'package:campsite/controller/spot_controller.dart';
import 'package:campsite/model/event.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/screens/add_new_spot_fill.dart';
import 'package:campsite/util/caravan_tour.dart';
import 'package:campsite/util/other_event.dart';
import 'package:campsite/util/resources.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  // List<String> _eventType = ["Meetup", "Campsite Cleanup", "Caravan Tours"];
  List<String> _eventType = Resources.eventType;
  List<String> _interestData = [
    "Vanlife Seekers",
    "Volunteering",
    "Surf",
    "Vanlife Projects",
    "Adventure",
    "Funtimes",
    "Meditation",
    "Art & Culture",
    "Hiking"
  ];
  String _selectedEventType;
  List _interests = List();
  List _spots = List();
  bool _progressBar = false;
  TextEditingController _txtAbout = TextEditingController();
  TextEditingController _txtEventName = TextEditingController();
  DateTime startDate;
  DateTime endDate;
  File _image;
  SpotModel _selectedSpotModel;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    // _selectedEventType = _eventType[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _progressBar
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Theme(
      data: ThemeData(
          brightness: Brightness.dark,
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Resources.mainColor)))),
                  child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _image == null
                      ? IconButton(
                          icon: Icon(FontAwesomeIcons.camera),
                          onPressed: () async {
                            getImage();
                          })
                      : Center(
                          child: GestureDetector(
                          child: Image.memory(
                            _image.readAsBytesSync(),
                            width: 200,
                          ),
                          onTap: () => getImage(),
                        )),
                  TextField(
                    controller: _txtEventName,
                    decoration: InputDecoration(
                      labelText: "Event Name",
                    ),
                  ),
                  DropdownButtonFormField(
                      value: _selectedEventType,
                      validator: (value) {
                        if (value == null) {
                          // return 'Please Select Category';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "Select Event Type"),
                      items: _eventType.map(
                        (category) {
                          return DropdownMenuItem(
                            child: Text(category),
                            value: category,
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEventType = value;
                        });
                      }),
                  _selectedSpotModel == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "SELECTED SPOT",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _selectedSpotModel.name,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Text(
                                    "${_selectedSpotModel.location.coordinates[1]},${_selectedSpotModel.location.coordinates[1]}",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  _selectedEventType == _eventType[2]
                      ? CaravanTourWidget(
                          onSelected: (spots) {
                            setState(() {
                              _spots = spots;
                            });
                          },
                        )
                      : _selectedEventType == _eventType[0]
                          ? OtherEventsWidget(onSelected: (spots) async {
                              if (spots[0] != null && spots[0] != "") {
                                SpotController().getById(spots[0]).then((value) {
                                  setState(() {
                                    _selectedSpotModel = value.data[0];
                                    _spots = spots;
                                  });
                                });
                              }
                            })
                          : _selectedEventType == _eventType[1]
                              ? OtherEventsWidget(
                                  onSelected: (spots) {
                                    setState(() {
                                      _spots = spots;
                                    });
                                  },
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _txtAbout,
                    decoration: InputDecoration(labelText: "About Event ?"),
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("When is your event happening?"),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    color: Colors.deepOrangeAccent,
                    onPressed: () async {
                      final List<DateTime> picked =
                          await DateRagePicker.showDatePicker(
                              context: context,
                              initialFirstDate: DateTime.now(),
                              initialLastDate:
                                  (DateTime.now()).add(Duration(days: 7)),
                              firstDate: DateTime(2019),
                              lastDate: DateTime(2030));
                      if (picked != null && picked.length == 2) {
                        print(picked);
                        setState(() {
                          startDate = picked[0];
                          endDate = picked[1];
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(startDate == null
                            ? "Start"
                            : startDate.toString().substring(0, 10)),
                        Text("|"),
                        Text(endDate == null
                            ? "END"
                            : endDate.toString().substring(0, 10)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Interests ?"),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: <Widget>[
                      // TagWidget(
                      //   "Vanlife Seekers",
                      //   onClicked: (status) {
                      //     if (status) {
                      //       _interests.add("Vanlife Seekers");
                      //     } else {
                      //       _interests.add("Vanlife Seekers");
                      //     }
                      //   },
                      // ),
                      for (var intrst in _interestData)
                        TagWidget(
                          intrst,
                          onClicked: (status) {
                            if (status) {
                              _interests.add(intrst);
                            } else {
                              _interests.add(intrst);
                            }
                          },
                        ),
                      // TagWidget("Volunteering"),
                      // TagWidget("Surf"),
                      // TagWidget("Vanlife Projects"),
                      // TagWidget("Adventure"),
                      // TagWidget("Funtimes"),
                      // TagWidget("Meditation"),
                      // TagWidget("Art & Culture"),
                      // TagWidget("Hiking"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      buttonColor: Resources.mainColor,
                      minWidth: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.075,
                      child: RaisedButton(
                        onPressed: () {
                          EventModel _eventModel = EventModel(
                              about: _txtAbout.text,
                              end: endDate.toIso8601String(),
                              eventName: _txtEventName.text,
                              eventType: _selectedEventType,
                              images: "",
                              interests: _interests,
                              start: startDate.toIso8601String(),
                              userID: Resources.userId,
                              spotID: _spots);

                          if (mounted)
                            setState(() {
                              _progressBar = true;
                            });
                          EventController()
                              .save(
                                  _image.readAsBytesSync(),
                                  _image.path.split(
                                      ".")[(_image.path.split(".").length) - 1],
                                  _eventModel)
                              .then((value) {
                            if (value.ok) {
                              if (mounted)
                                setState(() {
                                  _progressBar = false;
                                });
                              Fluttertoast.showToast(
                                  msg: "Succeddfully Spot Added !",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Resources.navigationKey.currentState
                                  .pushReplacementNamed('/mapHome');
                            } else {
                              print("FAILED");
                            }
                          });

                          // Resources.navigationKey.currentState
                          //     .pushReplacementNamed('/allInOne');
                        },
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        );
  }
}
