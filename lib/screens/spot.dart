import 'dart:ui';

import 'package:campsite/controller/checkin_controller.dart';
import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/model/checkin.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/screens/edit_spot.dart';
import 'package:campsite/util/avatarlist.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/util/spot_detail.dart';
import 'package:campsite/util/spot_review.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rating_bar/rating_bar.dart';

class SpotScreen extends StatefulWidget {
  SpotScreen(this.spotModel, this.rate);
  SpotModel spotModel;
  final int rate;
  @override
  _SpotScreenState createState() => _SpotScreenState();
}

class _SpotScreenState extends State<SpotScreen> {
  Color _detailButton = Colors.red;
  Color _detailText = Colors.white;
  Color _reviewButton = Colors.white;
  Color _reviewText = Colors.red;
  Widget _spotMenu;
  List<ImageProvider<dynamic>> imgs = List();
  Map<String, ProfileModel> _profiles = Map();
  List _checkinUsers = List();
  getCheckins(String spotID) async {
    RequestResult _req = await CheckinController().getBySpot(spotID);
    if (_req.data != null && _req.data.length > 0) {
      print("OOOOOOOOOOOOOOOOOOOOOOOB   :  "+ _req.data.toString());
        for (var userID in _req.data.first.userIDs) {
          RequestResult _reqProf = await ProfileController().getById(userID);
          setState(() {
            _profiles[userID] = _reqProf.data.first;
          });
        }

        setState(() {
          _checkinUsers = _req.data.first.userIDs;
        });
    }
  }

  ProfileModel _spotOwner = ProfileModel();
  getSpotOwner() async {
    RequestResult _reqProf =
        await ProfileController().getById(widget.spotModel.userID);
    setState(() {
      _spotOwner = _reqProf.data.first;
    });
  }

  @override
  void initState() {
    _spotMenu = SpotDetails(
        spotModel: widget.spotModel,
        onSpotChange: (spot) {
          setState(() {
            widget.spotModel = spot;
          });
        });
    setState(() {
      widget.spotModel.images.forEach((img) {
        imgs.add(NetworkImage(img));
      });
    });
    getCheckins(widget.spotModel.spotId);
    getSpotOwner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: sysWidth,
                        height: sysHeight * 0.3,
                        child: Stack(
                          children: <Widget>[
                            Carousel(
                                boxFit: BoxFit.cover,
                                autoplay: false,
                                animationCurve: Curves.fastOutSlowIn,
                                animationDuration: Duration(milliseconds: 1000),
                                dotSize: 6.0,
                                dotIncreasedColor: Colors.green,
                                dotBgColor: Colors.black38,
                                dotPosition: DotPosition.bottomCenter,
                                // dotVerticalPadding: 10.0,
                                showIndicator: true,
                                indicatorBgPadding: 7.0,
                                images: imgs),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              width: sysWidth * 0.3,
                              child: RatingBar(
                                initialRating: widget.rate.toDouble(),
                                maxRating: 5,
                                onRatingChanged: (rating) {},
                                filledIcon: FontAwesomeIcons.solidCircle,
                                emptyIcon: FontAwesomeIcons.solidCircle,
                                isHalfAllowed: false,
                                filledColor: Colors.red,
                                emptyColor: Colors.white,
                                size: 20,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              bottom: 10,
                              child: Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: ImageIcon(
                                        AssetImage("assets/icons/Share.png"),
                                        color: Colors.white),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: ImageIcon(
                                        AssetImage("assets/icons/navigate.png"),
                                        color: Colors.white),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: ImageIcon(
                                        AssetImage(
                                            "assets/icons/like_inactv.png"),
                                        color: Colors.white),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: ImageIcon(
                                        AssetImage(
                                            "assets/icons/Addpicture.png"),
                                        color: Colors.white),
                                    onPressed: () {},
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Location : "),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "${widget.spotModel.location.coordinates[1]}",
                                        style: TextStyle(
                                            color: Resources.mainBlackColor),
                                      ),
                                      TextSpan(
                                        text: " , ",
                                        style: TextStyle(
                                            color: Resources.mainBlackColor),
                                      ),
                                      TextSpan(
                                        text:
                                            "${widget.spotModel.location.coordinates[0]}",
                                        style: TextStyle(
                                            color: Resources.mainBlackColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("This spot is added by : "),
                                GestureDetector(
                                  onTap: () {
                                    Resources.navigationKey.currentState
                                        .pushNamed('/viewProfile',
                                            arguments: widget.spotModel.userID);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: sysWidth * 0.05,
                                        backgroundImage: _spotOwner.profPic !=
                                                null
                                            ? NetworkImage(_spotOwner.profPic)
                                            : NetworkImage(
                                                "https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'"),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      _spotOwner.profileName == null
                                          ? Text("Name Name")
                                          : Text(_spotOwner.profileName)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                _profiles.isEmpty
                                    ? Container()
                                    : AvatarList(_profiles.values.toList()),
                                Text(_checkinUsers.length.toString()),
                                Text(" HAVE BEEN THERE"),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (_checkinUsers
                                        .contains(Resources.userId)) {
                                      _checkinUsers.remove(Resources.userId);
                                    } else {
                                      _checkinUsers.add(Resources.userId);
                                    }
                                    CheckinController()
                                        .getBySpot(widget.spotModel.spotId)
                                        .then((value) {
                                      if (value.data.length > 0) {
                                        CheckinController()
                                            .update(widget.spotModel.spotId,
                                                _checkinUsers)
                                            .then((value) {
                                          getCheckins(widget.spotModel.spotId);
                                          setState(() {});
                                        });
                                      } else {
                                        CheckinController()
                                            .save(CheckinModel(
                                                spotID: widget.spotModel.spotId,
                                                userIDs: _checkinUsers))
                                            .then((value) {
                                          getCheckins(widget.spotModel.spotId);
                                          setState(() {});
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: sysWidth * 0.4,
                                    decoration: BoxDecoration(
                                      color: _checkinUsers
                                              .contains(Resources.userId)
                                          ? Colors.red
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      border: Border.all(
                                          color: Colors.red, width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Center(
                                        child:_checkinUsers
                                              .contains(Resources.userId)? Text(
                                          "CHECKED HERE",
                                          style: TextStyle(color: Colors.white),
                                        ): Text(
                                          "CHECK IN HERE",
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
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditSpotScreen(
                                                    widget.spotModel)));
                                  },
                                  child: Container(
                                    width: sysWidth * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      border: Border.all(
                                          color: Colors.red, width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Center(
                                        child: Text(
                                          "EDIT SPOT",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
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
                                    width: sysWidth * 0.5 - 10,
                                    decoration: BoxDecoration(
                                      color: _detailButton,
                                      border: Border.all(
                                          color: Colors.red, width: 2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Center(
                                        child: Text(
                                          "Details",
                                          style: TextStyle(color: _detailText),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _detailButton = Colors.red;
                                      _detailText = Colors.white;
                                      _reviewButton = Colors.white;
                                      _reviewText = Colors.red;
                                      _spotMenu = SpotDetails(
                                        show: true,
                                        spotModel: widget.spotModel,
                                        onSpotChange: (spot) {
                                          setState(() {
                                            widget.spotModel = spot;
                                          });
                                        },
                                      );
                                    });
                                  },
                                ),
                                GestureDetector(
                                    child: Container(
                                      width: sysWidth * 0.5 - 10,
                                      decoration: BoxDecoration(
                                        color: _reviewButton,
                                        border: Border.all(
                                            color: Colors.red, width: 2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Center(
                                          child: Text(
                                            "Review",
                                            style:
                                                TextStyle(color: _reviewText),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _detailButton = Colors.white;
                                        _detailText = Colors.red;
                                        _reviewButton = Colors.red;
                                        _reviewText = Colors.white;
                                        _spotMenu =
                                            SpotReview(widget.spotModel.spotId);
                                      });
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _spotMenu,
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: -10,
            left: 0,
            width: sysWidth,
            height: sysHeight * 0.1,
            child: Container(
              child: IconButton(
                  alignment: Alignment.centerLeft,
                  icon: Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: () {
                    Resources.navigationKey.currentState
                        .pushReplacementNamed('/mapHome');
                    // if (Resources.navigationKey.currentState.canPop()) {
                    //   Resources.navigationKey.currentState.pop();
                    // }
                  }),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white54, Colors.transparent]),
              ),
            ),
          ),
          Positioned(
              child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "TENERE SPOT",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
