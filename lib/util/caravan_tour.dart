import 'package:campsite/screens/event_caravan_add_map.dart';
import 'package:campsite/util/caravan_tour_map.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class CaravanTourWidget extends StatefulWidget {
  CaravanTourWidget({this.onSelected});
  Function(List spots) onSelected;
  @override
  _CaravanTourWidgetState createState() => _CaravanTourWidgetState();
}

class _CaravanTourWidgetState extends State<CaravanTourWidget> {
  int eventSpotNumber = 2;
  // List<String> eventSpotID = List();
  List<String> eventPlace = List();
  DateTime startDate;
  DateTime endDate;
  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.grey,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Where is your event Happening?"),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Starting Spot : "),
                        GestureDetector(
                          child: Container(
                            width: sysWidth * 0.5,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                eventPlace.length > 0 ? "Spot 1" : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                              ),
                            ),
                          ),
                          onTap: () async {
                            String txt = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EventCaravanAddMap()));

                            setState(() {
                              if (eventPlace.length > 0) {
                                eventPlace[0] = txt.split("@")[0];
                                // eventSpotID[0]=txt.split("@")[1];
                              } else {
                                eventPlace.add(txt.split("@")[0]);
                                // eventSpotID.add(txt.split("@")[1]);
                              }
                              widget.onSelected(eventPlace);
                              print(eventPlace);
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Icon(FontAwesomeIcons.gripLinesVertical),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Next Spot : "),
                        GestureDetector(
                          child: Container(
                            width: sysWidth * 0.5,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                eventPlace.length > 1 ? "Spot 2" : "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                              ),
                            ),
                          ),
                          onTap: () async {
                            String txt = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EventCaravanAddMap()));
                            setState(() {
                              if (eventPlace.length > 1) {
                                eventPlace[1] = txt.split("@")[0];
                                // eventSpotID[1]=txt.split("@")[1];
                              } else {
                                eventPlace.add(txt.split("@")[0]);
                                // eventSpotID.add(txt.split("@")[1]);
                              }
                              widget.onSelected(eventPlace);
                              print(eventPlace);
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Icon(FontAwesomeIcons.gripLinesVertical),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                for (int i = 2; i < eventSpotNumber; i++)
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Next Spot : "),
                          GestureDetector(
                            child: Container(
                              width: sysWidth * 0.5,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  eventPlace.length > i ? "Spot ${i + 1}" : "",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                              ),
                            ),
                            onTap: () async {
                              String txt = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EventCaravanAddMap()));
                              setState(() {
                                if (eventPlace.length > i) {
                                  eventPlace[i] = txt.split("@")[0];
                                  // eventSpotID[i]=txt.split("@")[1];
                                } else {
                                  eventPlace.add(txt.split("@")[0]);
                                  // eventSpotID.add(txt.split("@")[1]);
                                }
                                widget.onSelected(eventPlace);
                                print(eventPlace);
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Icon(FontAwesomeIcons.gripLinesVertical),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                SizedBox(
                  height: 5,
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
                      onPressed: () {
                        setState(() {
                          eventSpotNumber++;
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
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
        // Text("When is your event happening?"),
        // SizedBox(
        //   height: 10,
        // ),
        // MaterialButton(
        //   color: Colors.deepOrangeAccent,
        //   onPressed: () async {
        //     final List<DateTime> picked = await DateRagePicker.showDatePicker(
        //         context: context,
        //         initialFirstDate: DateTime.now(),
        //         initialLastDate: (DateTime.now()).add(Duration(days: 7)),
        //         firstDate: DateTime(2019),
        //         lastDate: DateTime(2030));
        //     if (picked != null && picked.length == 2) {
        //       print(picked);
        //       setState(() {
        //         startDate = picked[0];
        //         endDate = picked[1];
        //       });
        //     }
        //   },
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: <Widget>[
        //       Text(startDate == null
        //           ? "Start"
        //           : startDate.toString().substring(0, 10)),
        //       Text("|"),
        //       Text(endDate == null
        //           ? "END"
        //           : endDate.toString().substring(0, 10)),
        //     ],
        //   ),
        // )
      ],
    );
  }
}
