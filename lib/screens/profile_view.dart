import 'dart:async';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:campsite/controller/checkin_controller.dart';
import 'package:campsite/controller/friends_controller.dart';
import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/controller/spot_controller.dart';
import 'package:campsite/model/SpotSeparate.dart';
import 'package:campsite/model/friends.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/screens/edit_profile.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/util/profile_map.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:campsite/model/notifymsg.dart';

class ProfileViewScreen extends StatefulWidget {
  // ProfileViewScreen(this.userid);
  // final String userid;
  @override
  _ProfileViewScreenState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen>
    with SingleTickerProviderStateMixin {
  bool init = false;
  bool _progressBarActive = true;
  final List<Tab> tabs = <Tab>[
    new Tab(text: "Favourite Spots"),
    new Tab(text: "Friends"),
    new Tab(text: "Events")
  ];

  int checkingNumbers = 0;
  getCheckinsByUser(String userID) async {
    await CheckinController().getByUser(userID).then((value) {
      if (value.ok) {
        setState(() {
          checkingNumbers = value.data.length;
        });
      }
    });
  }

  getSpotsByUser(String userID) async {
    await SpotController().getSeparateByUser(userID).then((value) {
      if (value.data != null && value.data.length > 0) {
        campsite.clear();
        wildSpot.clear();
        parking.clear();
        rvPark.clear();
        _allSpotsbyUser.clear();
        if (value.ok) {
          setState(() {
            SpotSeparateModel separateModel = value.data.first;
            for (SpotModel spotModel in separateModel.campsite) {
              campsite.add(LatLng(spotModel.location.coordinates[1],
                  spotModel.location.coordinates[0]));
              _allSpotsbyUser.add(spotModel);
            }
            for (SpotModel spotModel in separateModel.wildSpots) {
              wildSpot.add(LatLng(spotModel.location.coordinates[1],
                  spotModel.location.coordinates[0]));
              _allSpotsbyUser.add(spotModel);
            }
            for (SpotModel spotModel in separateModel.parking) {
              parking.add(LatLng(spotModel.location.coordinates[1],
                  spotModel.location.coordinates[0]));
              _allSpotsbyUser.add(spotModel);
            }
            for (SpotModel spotModel in separateModel.rvPark) {
              rvPark.add(LatLng(spotModel.location.coordinates[1],
                  spotModel.location.coordinates[0]));
              _allSpotsbyUser.add(spotModel);
            }
          });
        }

        print("EEEEEEEEEEEEEEEEEEEEEEEEEEE     " +
            _allSpotsbyUser.length.toString());
      }
    });
  }

  TabController _tabController;

  Color layerIconColor = Colors.black;
  Color positionIconColor = Colors.black;
  MapType mapType = MapType.normal;

  GoogleMapController _googleMapController;

  Map<String, ProfileModel> _profiles = Map();

  List _friends = List();
  getFriends(String userID) async {
    RequestResult _req = await FriendsController().getByUser(userID);
    if (_req.data.length > 0) {
      for (var userID in _req.data.first.friends) {
        RequestResult _reqProf = await ProfileController().getById(userID);
        setState(() {
          _profiles[userID] = _reqProf.data.first;
        });
      }
      setState(() {
        _friends = _req.data.first.friends;
      });
    }
  }

  Set<Marker> markers = Set();
  void _onMapCreated(GoogleMapController mapController) async {
    print("onMapCreated");
    setState(() {
      _googleMapController = mapController;
    });
  }

  ProfileModel _profileModel = ProfileModel();
  ProfileController _profileController = ProfileController();

  List<LatLng> wildSpot = [
    LatLng(30.417226, -9.573561),
    LatLng(30.402384, -9.575387),
    LatLng(30.415170, -9.553270)
  ];
  List<LatLng> parking = [
    LatLng(30.419501, -9.579113),
    LatLng(30.432355, -9.568744)
  ];
  List<LatLng> campsite = [
    LatLng(30.425160, -9.578384),
    LatLng(30.419920, -9.561209),
    LatLng(30.397632, -9.555944)
  ];
  List<LatLng> rvPark = [
    LatLng(30.412235, -9.587863),
    LatLng(30.412934, -9.566313)
  ];

  void getUserDetails(String userId) async {
    RequestResult result = await _profileController.getById(userId);
    if (result.ok) {
      setState(() {
        _profileModel = result.data.first;
        print(_profileModel);
        _progressBarActive = false;
      });
    }
  }

  setMarkers() {
    setState(() {
      markers.clear();
      for (LatLng latlng in wildSpot) {
        markers.add(Marker(
          markerId: MarkerId("${latlng.hashCode}"),
          position: latlng,
          icon: Resources.wildSpotIconS,
        ));
      }
      for (LatLng latlng in parking) {
        markers.add(Marker(
          markerId: MarkerId("${latlng.hashCode}"),
          position: latlng,
          icon: Resources.parkingIconS,
        ));
      }

      for (LatLng latlng in campsite) {
        markers.add(Marker(
          markerId: MarkerId("${latlng.hashCode}"),
          position: latlng,
          icon: Resources.campsiteIconS,
        ));
      }

      for (LatLng latlng in rvPark) {
        markers.add(Marker(
          markerId: MarkerId("${latlng.hashCode}"),
          position: latlng,
          icon: Resources.rvParkIconS,
        ));
      }
      if (_googleMapController != null) {
        _googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: wildSpot.length > 0
              ? wildSpot.first
              : campsite.length > 0
                  ? campsite.first
                  : parking.length > 0
                      ? parking.first
                      : rvPark.length > 0 ? rvPark.first : LatLng(0, 0),
          zoom: 14.4746,
        )));
      }
    });
  }

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: tabs.length);

    setMarkers();

    getFriends(Resources.userId);
    super.initState();
  }

  List<SpotModel> _allSpotsbyUser = List();
  // setAllSpotsByUser() async {
  //   var req = await SpotController().getByUser(_profileModel.id);
  //   setState(() {
  //     _allSpotsbyUser = req.data;
  //   });
  // }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userID = ModalRoute.of(context).settings.arguments;
    if (!init) {
      getUserDetails(userID);
      getCheckinsByUser(userID);
      getSpotsByUser(userID);
      setMarkers();
      init = true;
    }
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(
          brightness: Brightness.dark,
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Resources.mainColor)))),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _progressBarActive == true
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: <Widget>[
                  LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: sysWidth,
                                height: sysHeight * 0.39,
                                child: Stack(
                                  children: <Widget>[
                                    _profileModel.coverPic != null
                                        ? Image(
                                            width: sysWidth,
                                            height: sysHeight * 0.3,
                                            // image: NetworkImage(
                                            //     'https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'),
                                            image: (_profileModel.coverPic !=
                                                        null &&
                                                    _profileModel.coverPic !=
                                                        "")
                                                ? NetworkImage(
                                                    _profileModel.coverPic)
                                                : AssetImage(
                                                    'assets/add_image.png'),
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: sysWidth,
                                            height: sysHeight * 0.3,
                                          ),
                                    Positioned(
                                      bottom: sysHeight * 0.02,
                                      left: 20,
                                      child: CircleAvatar(
                                        // backgroundImage: NetworkImage(
                                        //     'https://img.traveltriangle.com/blog/wp-content/uploads/2015/06/Cover1.jpg'),
                                        backgroundImage:
                                            _profileModel.profPic != null
                                                ? NetworkImage(
                                                    _profileModel.profPic)
                                                : null,
                                        radius: sysHeight * 0.07,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: sysHeight * 0.04,
                                      left: (sysHeight * 0.14),
                                      child: GestureDetector(
                                          child: _friends.contains(userID)
                                              ? Image.asset(
                                                  "assets/addFriend_act.png")
                                              : Image.asset(
                                                  "assets/addFriend.png"),
                                          onTap: () async {
                                            if (_friends.contains(userID)) {
                                              _friends.remove(userID);
                                              Fluttertoast.showToast(
                                                  msg: "Unfriend",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIos: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            } else {
                                              _friends.add(userID);
                                              Fluttertoast.showToast(
                                                  msg: "Friend Added !",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIos: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }

                                            FriendsController()
                                                .getByUser(Resources.userId)
                                                .then((friends) => {
                                                      if (friends.data.length <
                                                          1)
                                                        {
                                                          if (_friends.length >
                                                              0)
                                                            {
                                                              print("AAAAAAAAAAAAAAAAAAAA     " +
                                                                  friends.data
                                                                      .length
                                                                      .toString()),
                                                              FriendsController()
                                                                  .save(FriendsModel(
                                                                      userID: Resources
                                                                          .userId,
                                                                      friends:
                                                                          _friends))
                                                                  .then(
                                                                      (value) {
                                                                Resources.addNotifications(
                                                                        userID,
                                                                        NotifymsgModel(
                                                                            profileId: Resources
                                                                                .userId,
                                                                            msg:
                                                                                "A new friend Request.",
                                                                            url:
                                                                                "/friendrequestaccept"))
                                                                    .then((value) =>
                                                                        setState(
                                                                            () {}));
                                                              }),
                                                            }
                                                        }
                                                      else
                                                        {
                                                          print("BBBBBBBBBBBBBBBBBBBBBBBB     " +
                                                              friends
                                                                  .data.length
                                                                  .toString()),
                                                          FriendsController()
                                                              .update(
                                                                  Resources
                                                                      .userId,
                                                                  _friends)
                                                              .then((value) {
                                                            Resources.addNotifications(
                                                                    userID,
                                                                    NotifymsgModel(
                                                                        profileId:
                                                                            Resources
                                                                                .userId,
                                                                        msg:
                                                                            "A new friend Request.",
                                                                        url:
                                                                            "/friendrequestaccept"))
                                                                .then((value) =>
                                                                    setState(
                                                                        () {}));
                                                          }),
                                                        }
                                                    });

                                            // FriendsModel(friends: )
                                          }),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 20,
                                      child: Container(
                                        width: sysHeight * 0.14,
                                        height: sysHeight * 0.02,
                                        child: Center(
                                          // child: Text("Erin Wilson"),
                                          child: Text(
                                              _profileModel.profileName == null
                                                  ? ""
                                                  : _profileModel.profileName),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: sysWidth -
                                            ((sysHeight * 0.14) + 50),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text("SPOTS"),
                                                  Text(
                                                    (campsite.length +
                                                            wildSpot.length +
                                                            rvPark.length +
                                                            parking.length)
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 30),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text("CHECK-INS"),
                                                  Text(
                                                    checkingNumbers.toString(),
                                                    style:
                                                        TextStyle(fontSize: 30),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text("CLEANUPS"),
                                                  Text(
                                                    "0",
                                                    style:
                                                        TextStyle(fontSize: 30),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                                icon: ImageIcon(
                                                  AssetImage(
                                                      "assets/instg.png"),
                                                  color: Resources.mainColor,
                                                ),
                                                onPressed: () async {
                                                  if (_profileModel
                                                              .whatsappAcc !=
                                                          null &&
                                                      _profileModel
                                                              .whatsappAcc !=
                                                          "") {
                                                    var instaUrl =
                                                        "http://instagram.com/_u/${_profileModel.instaAcc}";
                                                    await canLaunch(instaUrl)
                                                        ? launch(instaUrl)
                                                        : print(
                                                            "open instagram app link or do a snackbar with notification that there is no instagram installed");
                                                  }
                                                }),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                                icon: ImageIcon(
                                                    AssetImage(
                                                        "assets/whatsapp.png"),
                                                    color: Resources.mainColor),
                                                onPressed: () async {
                                                  if (_profileModel
                                                              .whatsappAcc !=
                                                          null &&
                                                      _profileModel
                                                              .whatsappAcc !=
                                                          "") {
                                                    var whatsappUrl =
                                                        "whatsapp://send?phone=${_profileModel.whatsappAcc}";
                                                    await canLaunch(whatsappUrl)
                                                        ? launch(whatsappUrl)
                                                        : print(
                                                            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                                                  }
                                                }),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text("VAN NAME"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              // "ANZAVAN",
                                              _profileModel.vanName == null
                                                  ? ""
                                                  : _profileModel.vanName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text("VEHIVLE TYPE"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              // "VW T3",
                                              _profileModel.vehicleType == null
                                                  ? ""
                                                  : _profileModel.vehicleType,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text("TRAVELLER STATUS"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              // "Full Time",
                                              _profileModel.travStatus == null
                                                  ? ""
                                                  : _profileModel.travStatus,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text("ABOUT ME"),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    // Text(
                                    //     "Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression.  Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500"),
                                    Text(_profileModel.aboutUs == null
                                        ? ""
                                        : _profileModel.aboutUs),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Stack(children: <Widget>[
                                      Container(
                                        width: sysWidth,
                                        height: sysHeight * 0.3,
                                        child: GoogleMap(
                                          onMapCreated: _onMapCreated,
                                          mapType: mapType,
                                          initialCameraPosition: CameraPosition(
                                            target: wildSpot.length > 0
                                                ? wildSpot.first
                                                : LatLng(0, 0),
                                            zoom: 14.4746,
                                          ),
                                          markers: markers,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: ImageIcon(
                                            AssetImage("assets/map_grow.png"),
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Resources.navigationKey.currentState
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileMap(
                                                  spots: _allSpotsbyUser,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ]),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 00,
                    left: 0,
                    width: sysWidth,
                    height: sysHeight * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Container(
                        //   child: Text("ASDASDF"),
                        //   decoration: BoxDecoration(
                        //     gradient: LinearGradient(
                        //         begin: Alignment.topCenter,
                        //         end: Alignment.bottomCenter,
                        //         colors: [Colors.white54, Colors.transparent]),
                        //   ),
                        // ),

                        Container(
                          child: IconButton(
                              alignment: Alignment.centerLeft,
                              icon: Icon(
                                FontAwesomeIcons.arrowLeft,
                                color: Colors.white,
                                size: 50,
                              ),
                              onPressed: () {
                                if (Resources.navigationKey.currentState
                                    .canPop()) {
                                  Resources.navigationKey.currentState.pop();
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
