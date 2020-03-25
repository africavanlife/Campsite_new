import 'package:campsite/controller/checkin_controller.dart';
import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/controller/review_controller.dart';
import 'package:campsite/controller/spot_controller.dart';
import 'package:campsite/model/event.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/model/review.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/screens/add_new_spot_fill.dart';
import 'package:campsite/util/avatarlist.dart';
import 'package:campsite/util/icon_buttons.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/util/review.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';

class CommunityDetailsScreen extends StatefulWidget {
  @override
  _CommunityDetailsScreenState createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  String _startingAddress = "";
  String _endAddress = "";
  List<ReviewModel> _reviews = List();
  Map<String, ProfileModel> _reviewUsers = Map();

  getAllReviews(String eventID) async {
    _reviews.clear();
    _reviewUsers.clear();
    RequestResult _req = await ReviewController().getAllBySpot(eventID);
  setState(() {
      _reviews = _req.data;
    });
    for (ReviewModel _review in _reviews) {
      RequestResult _rq = await ProfileController().getById(_review.userID);
      setState(() {
        _reviewUsers[_review.userID] = (_rq.data.first);
      });
    }
  
  }

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

  ProfileModel _profileModel;
  getProfile(String userID) async {
    RequestResult _req = await ProfileController().getById(userID);
    setState(() {
      _profileModel = _req.data.first;
    });
  }





  

  bool isInitialized = false;
  @override
  void initState() {
    super.initState();
  }

  EventModel _eventModel;
  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      isInitialized = true;
      _eventModel = ModalRoute.of(context).settings.arguments;

      if (_eventModel.eventType == Resources.eventType[2]) {
        if (_eventModel.spotID.length > 0) {
          getStartAddress(_eventModel.spotID.first);
          getEndAddress(_eventModel.spotID.last);
        }
      } else {
        if (_eventModel.spotID.length > 0) {
          getStartAddress(_eventModel.spotID.first);
        }
      }
      getProfile(_eventModel.userID);
      getAllReviews(_eventModel.id);
    }
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Container(
              width: sysWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: sysWidth - 20,
                    // height: sysHeight * 0.4,
                    color: Resources.mainWhiteColor,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            _eventModel.images == null
                                ? Container()
                                : Image(
                                    width: (sysWidth - 20),
                                    height: sysHeight * 0.3,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(_eventModel.images),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _eventModel.eventName ==
                                          Resources.eventType[2]
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Starting : ${_startingAddress}",
                                              style: TextStyle(
                                                  color:
                                                      Resources.mainBlackColor),
                                            ),
                                            Text(
                                              "|",
                                              style: TextStyle(
                                                  color:
                                                      Resources.mainBlackColor),
                                            ),
                                            Text(
                                              "End : ${_endAddress}",
                                              style: TextStyle(
                                                  color:
                                                      Resources.mainBlackColor),
                                            )
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "City : ${_startingAddress}",
                                              style: TextStyle(
                                                  color:
                                                      Resources.mainBlackColor),
                                            ),
                                          ],
                                        ),
                                  Row(
                                    children: <Widget>[
                                      _profileModel == null
                                          ? Container()
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  _profileModel.profPic),
                                              radius: 20,
                                            ),
                                      Text(
                                        _profileModel == null
                                            ? ""
                                            : _profileModel.profileName,
                                        style: TextStyle(
                                            color: Resources.mainBlackColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          child: AIconButtons(
                            false,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        _eventModel.about,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Flexible(
                                        child: Text(
                                      _eventModel.eventType,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      // AvatarList(),
                      Text("+82"),
                      Text(" MORE HAVE BEEN THERE"),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: sysWidth * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Center(
                              child: Text(
                                "JOIN",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: sysWidth * 0.05,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: sysWidth * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Center(
                              child: Text(
                                "INVITE",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_eventModel.start),
                            Text(
                              "|",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_eventModel.end)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("ABOUT EVENT"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(_eventModel.about),
                  SizedBox(
                    height: 20,
                  ),
                  Text("INTERESTS"),
                  Wrap(
                    children: <Widget>[
                      for (String intrst in _eventModel.interests)
                        TagWidget(
                          intrst,
                          show: true,
                        )
                      // TagWidget("Vanlife Seekers"),
                      // TagWidget("Volunteering"),
                      // TagWidget("Vanlife Project"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  // ReviewWidget(
                  //   comment:
                  //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  //   image: NetworkImage(
                  //       'https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'),
                  //   name: "Victoria Bank",
                  //   initHeartValue: 10,
                  //   isHeart: false,
                  //   lastday: 5,
                  //   showRatingbar: false,
                  //   initRating: 4,
                  // ),
                  // ReviewWidget(
                  //   comment:
                  //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  //   image: NetworkImage(
                  //       'https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'),
                  //   name: "Second Name",
                  //   initHeartValue: 20,
                  //   isHeart: true,
                  //   lastday: 7,
                  //   showRatingbar: false,
                  //   initRating: 4,
                  // ),
                  // ReviewWidget(
                  //   comment:
                  //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  //   image: NetworkImage(
                  //       'https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'),
                  //   name: "Third Name",
                  //   initHeartValue: 18,
                  //   isHeart: true,
                  //   lastday: 10,
                  //   showRatingbar: false,
                  //   initRating: 4,
                  // ),
                  for (ReviewModel _reviewModel in _reviews)
                    _reviewUsers[_reviewModel.userID] == null
                        ? Container()
                        : ReviewWidget(
                            comment: _reviewModel.review,
                            image: NetworkImage(
                                _reviewUsers[_reviewModel.userID].profPic),
                            name: _reviewUsers[_reviewModel.userID].profileName,
                            initHeartValue: _reviewModel.likes,
                            isHeart: false,
                            lastday: DateTime.parse(_reviewModel.updatedAt)
                                .difference(DateTime.now())
                                .inHours,
                            showRatingbar: false,
                            initRating: _reviewModel.rate.toDouble(),
                          ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        hintText: "WRITE A COMMENT",
                        fillColor: Colors.white70),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      child: Container(
                        width: sysWidth * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Center(
                            child: Text(
                              "LOAD MORE",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: sysWidth,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: IconButton(
                  alignment: Alignment.centerLeft,
                  icon: Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: () {
                    if (Resources.navigationKey.currentState.canPop()) {
                      Resources.navigationKey.currentState.pop();
                    }
                  }),
            ))
      ],
    );
  }
}
