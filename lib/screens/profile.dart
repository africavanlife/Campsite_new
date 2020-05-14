import 'dart:async';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:campsite/controller/checkin_controller.dart';
import 'package:campsite/controller/favorite_controller.dart';
import 'package:campsite/controller/friends_controller.dart';
import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/controller/review_controller.dart';
import 'package:campsite/controller/spot_controller.dart';
import 'package:campsite/model/SpotSeparate.dart';
import 'package:campsite/model/favourite.dart';
import 'package:campsite/model/notifications.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/screens/edit_profile.dart';
import 'package:campsite/screens/spot.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/util/profile_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _progressBarActive = true;
  final List<Tab> tabs = <Tab>[
    new Tab(text: "Favourite Spots"),
    new Tab(text: "Friends"),
    new Tab(text: "Events")
  ];

  TabController _tabController;

  Color layerIconColor = Colors.black;
  Color positionIconColor = Colors.black;
  MapType mapType = MapType.normal;

  GoogleMapController _googleMapController;

  Map<String, ProfileModel> _profiles = Map();

  List<NotificationsModel> _notifications = List();
  getNotifications() async {
    _notifications.clear();
    Resources.getNotifications().then((value) => {
          setState(() {
            _notifications = value;
          })
        });
  }

  List _friends = List();
  getFriends(String userID) async {
    RequestResult _req = await FriendsController().getByUser(userID);

    if (_req.data != null && _req.data.length > 0) {
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

  List<ProfileModel> _followers = List();
  List<ProfileModel> _followings = List();

  getFollowDetails() async {
    var lst1 = List<ProfileModel>();
    var lst2 = List<ProfileModel>();
    await FriendsController().getByUser(Resources.userId).then((req) async => {
          req.data.forEach((friendlist) {
            friendlist.friends.forEach((id) {
              ProfileController().getById(id).then((value) => {
                    lst1.add(value.data[0]),
                  });
            });
          }),
          await FriendsController()
              .getByFriend(Resources.userId)
              .then((requ) => {
                    requ.data.forEach((friendli) {
                      friendli.friends.forEach((id) {
                        ProfileController().getById(id).then((value) => {
                              lst2.add(value.data[0]),
                            });
                      });
                    }),
                  }),
          setState(() {
            _followers = lst1;
            _followings = lst2;
          }),
          print("GGGGGGGGGGGGGGGGGG" +
              _followers.length.toString() +
              " : " +
              _followings.length.toString()),
        });
    // var req = (await FriendsController().getByUser(Resources.userId));
    // var requ = (await FriendsController().getByFriend(Resources.userId));
    // var lst1 = List<ProfileModel>();
    // req.data.forEach((friendlist) {
    //   friendlist.friends.forEach((id) async {
    //     lst1.add((await ProfileController().getById(id)).data[0]);
    //   });
    // });

    // var lst2 = List<ProfileModel>();
    // requ.data.forEach((friendlist) {
    //   friendlist.friends.forEach((id) async {
    //     lst2.add((await ProfileController().getById(id)).data[0]);
    //   });
    // });
  }

  int checkingNumbers = 0;
  getCheckinsByUser(String userID) async {
    await CheckinController().getByUser(userID).then((value) {
      if (value.ok && value.data.length > 0) {
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

  List<SpotModel> _favourite = List();
  getFavourites(String userID) async {
    RequestResult _req =
        await FavouriteController().getByUser(Resources.userId);
    _favourite.clear();
    if (_req.data != null && _req.data.length > 0) {
      for (var spot in _req.data.first.spotID) {
        await SpotController().getById(spot).then((value) {
          setState(() {
            _favourite.add(value.data.first);
          });
        });
      }
    } else {
      setState(() {});
    }
    print("WWWWWWWWWWWWW  : " + _favourite.toString());
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
    });
  }

  Set<Marker> markers = Set();
  void _onMapCreated(GoogleMapController mapController) async {
    print("onMapCreated");
    _googleMapController = mapController;
    setMarkers();
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

  List<SpotModel> _allSpotsbyUser = List();
  // setAllSpotsByUser() async {
  //   SpotController()
  //       .getSeparateByUser(_profileModel.id)
  //       .then((req) => setState(() {
  //             SpotSeparateModel sepSpot = req.data[0];

  //             _allSpotsbyUser.addAll(sepSpot.campsite);
  //             _allSpotsbyUser.addAll(sepSpot.wildSpots);
  //             _allSpotsbyUser.addAll(sepSpot.parking);
  //             _allSpotsbyUser.addAll(sepSpot.rvPark);
  //             print("EEEEEEEEEEEEEEEEEEEEEEEEEEEEE   :" +
  //                 _allSpotsbyUser.length.toString() +
  //                 "      " +
  //                 _profileModel.id);
  //           }));
  // }

  @override
  void initState() {
    getUserDetails(Resources.userId);
    getCheckinsByUser(Resources.userId);
    getSpotsByUser(Resources.userId);
    getFollowDetails();
    _tabController = new TabController(vsync: this, length: tabs.length);

    getFriends(Resources.userId);
    getFavourites(Resources.userId);
    super.initState();

    // setAllSpotsByUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                                          image: NetworkImage(
                                              _profileModel.coverPic),
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
                                      backgroundImage: _profileModel.profPic !=
                                              null
                                          ? NetworkImage(_profileModel.profPic)
                                          : null,
                                      radius: sysHeight * 0.07,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: sysHeight * 0.04,
                                    left: sysHeight * 0.14,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: CircleAvatar(
                                          radius: 10,
                                          child: Icon(FontAwesomeIcons.bell)),
                                      // child: _friends.length > 0
                                      //     ? CircleAvatar(
                                      //         radius: 10,
                                      //         backgroundColor: Colors.blue,
                                      //         child: Text(
                                      //           _friends.length.toString(),
                                      //           style: TextStyle(
                                      //               color: Colors.white),
                                      //         ),
                                      //       )
                                      //     : Container(),
                                    ),
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
                                      width:
                                          sysWidth - ((sysHeight * 0.14) + 50),
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
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                              icon: ImageIcon(
                                                AssetImage("assets/instg.png"),
                                                color: Resources.mainColor,
                                              ),
                                              onPressed: () async {
                                                var instaUrl =
                                                    "http://instagram.com/_u/${_profileModel.instaAcc}";
                                                await canLaunch(instaUrl)
                                                    ? launch(instaUrl)
                                                    : print(
                                                        "open instagram app link or do a snackbar with notification that there is no instagram installed");
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
                                                var whatsappUrl =
                                                    "whatsapp://send?phone=${_profileModel.whatsappAcc}";
                                                await canLaunch(whatsappUrl)
                                                    ? launch(whatsappUrl)
                                                    : print(
                                                        "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                                              }),
                                        ],
                                      ),

                                      GestureDetector(
                                          onTap: () {
                                            Resources.navigationKey.currentState
                                                .pushNamed(
                                                    '/viewProfileFriends');
                                          },
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(children: <Widget>[
                                                    Text("Followers"),
                                                    Text(_followers.length
                                                        .toString())
                                                  ]),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(children: <Widget>[
                                                    Text("Followings"),
                                                    Text(_followings.length
                                                        .toString())
                                                  ]),
                                                )
                                              ])),

                                      // Row(
                                      //   children: <Widget>[
                                      //     Text("NOTIFICATIONS"),
                                      //     SizedBox(
                                      //       width: 5,
                                      //     ),
                                      //     _notifications.length > 0
                                      //         ? CircleAvatar(
                                      //             radius: 10,
                                      //             backgroundColor:
                                      //                 Resources.mainColor,
                                      //             child: Text(_notifications
                                      //                 .length
                                      //                 .toString()),
                                      //           )
                                      //         : Container(),
                                      //   ],
                                      // )
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
                                              builder: (context) => ProfileMap(
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
                                  TabBar(
                                    // isScrollable: true,
                                    labelPadding: EdgeInsets.all(10),
                                    unselectedLabelColor: Colors.grey,
                                    labelColor: Colors.white,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicator: new BubbleTabIndicator(
                                      indicatorHeight: 25.0,
                                      indicatorColor: Resources.mainColor,
                                      tabBarIndicatorSize:
                                          TabBarIndicatorSize.tab,
                                    ),
                                    tabs: tabs,
                                    controller: _tabController,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: sysWidth,
                              height: sysHeight * 0.7,
                              child: TabBarView(
                                controller: _tabController,
                                children: tabs.map((Tab tab) {
                                  if (tab == tabs[0]) {
                                    return StaggeredGridView.countBuilder(
                                      shrinkWrap: true,
                                      crossAxisCount: 4,
                                      itemCount: _favourite.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              Card(
                                        elevation: 0.5,
                                        child: GestureDetector(
                                          onTap: () async {
                                            var rate = await ReviewController()
                                                .getReviewBySpotId(
                                                    _favourite[index].spotId);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SpotScreen(
                                                            _favourite[index],
                                                            rate)));
                                          },
                                          child: Container(
                                            child: Column(
                                              children: <Widget>[
                                                Image(
                                                  height: 150,
                                                  width: sysWidth * 0.5,
                                                  image: NetworkImage(
                                                      _favourite[index]
                                                          .images
                                                          .first),
                                                  fit: BoxFit.cover,
                                                ),
                                                Text(_favourite[index].name),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      staggeredTileBuilder: (int index) =>
                                          new StaggeredTile.count(2, 2),
                                      mainAxisSpacing: 4.0,
                                      crossAxisSpacing: 4.0,
                                    );
                                  } else if (tab == tabs[1]) {
                                    return ListView.builder(
                                        itemCount: _friends.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int idx) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  _profiles[_friends[idx]]
                                                      .profPic),
                                            ),
                                            title: Text(_profiles[_friends[idx]]
                                                .profileName),
                                          );
                                        });
                                  } else {
                                    return Container(
                                      child: Text(tabs[2].text),
                                    );
                                  }
                                }).toList(),
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
                              size: 30,
                            ),
                            onPressed: () {
                              if (Resources.navigationKey.currentState
                                  .canPop()) {
                                Resources.navigationKey.currentState.pop();
                              }
                            }),
                      ),
                      Container(
                        width: sysWidth * 0.3,
                        child: ButtonTheme(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          buttonColor: Colors.transparent,
                          minWidth: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  "EDIT PROFILE",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                ImageIcon(
                                  AssetImage("assets/editprofile.png"),
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
