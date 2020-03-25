import 'package:campsite/screens/add_event.dart';
import 'package:campsite/screens/add_new_spot_map.dart';
import 'package:campsite/util/resources.dart';
import 'package:flutter/material.dart';

class AllInOneScreen extends StatefulWidget {
  @override
  _AllInOneScreenState createState() => _AllInOneScreenState();
}

class _AllInOneScreenState extends State<AllInOneScreen> {
  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg_allinone.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: sysWidth,
            height: sysHeight * 0.15,
            child: Center(
              child: Text(
                "ALL IN ONE",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Resources.mainWhiteColor),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white12,
                  ]),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    // // Navigator.push(
                    // //     context,
                    // //     MaterialPageRoute(
                    // //         builder: (context) => AddNewSpotMap()));
                    // Navigator.pushNamed(context, '/home/allInOne/addSpotMap');
                    Resources.navigationKey.currentState
                        .pushNamed("/addSpotMap");
                  },
                  child: Card(
                    elevation: 0.5,
                    child: Container(
                      width: sysWidth,
                      height: sysHeight * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "ADD YOUR FAVOURITE SPOTS",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text("Beautiful Places have beautiful stories")
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Resources.navigationKey.currentState.pushNamed("/addEvent");
                  },
                  child: Card(
                    elevation: 0.5,
                    child: Container(
                      width: sysWidth,
                      height: sysHeight * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Create Event",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text("Happiness is real, only when it is shared")
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Card(
                    elevation: 0.5,
                    child: Container(
                      width: sysWidth,
                      height: sysHeight * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Share Your Stories",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text("#Vanlife")
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
