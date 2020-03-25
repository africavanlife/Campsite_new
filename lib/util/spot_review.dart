import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/controller/review_controller.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/model/review.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/review.dart';
import 'package:flutter/material.dart';

class SpotReview extends StatefulWidget {
  SpotReview(this.spotID);
  final String spotID;
  @override
  _SpotReviewState createState() => _SpotReviewState();
}

class _SpotReviewState extends State<SpotReview> {
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

  @override
  void initState() {
    getAllReviews(widget.spotID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.topRight,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Center(
                  child: Text(
                    "RATE SPOT",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "${_reviews.length} Recommendations",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        SizedBox(
          height: 20,
        ),
        // ReviewWidget(
        //   comment:
        //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        //   image: NetworkImage(
        //       'https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'),
        //   name: "First Name",
        //   initHeartValue: 10,
        //   isHeart: true,
        //   lastday: 7,
        //   showRatingbar: true,
        //   initRating: 4,
        // ),
        // ReviewWidget(
        //   comment:
        //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        //   image: NetworkImage(
        //       'https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'),
        //   name: "Second Name",
        //   initHeartValue: 20,
        //   isHeart: false,
        //   lastday: 10,
        //   showRatingbar: true,
        //   initRating: 3,
        // ),
        // ReviewWidget(
        //   comment:
        //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        //   image: NetworkImage(
        //       'https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'),
        //   name: "Third Name",
        //   initHeartValue: 30,
        //   isHeart: true,
        //   lastday: 25,
        //   showRatingbar: true,
        //   initRating: 5,
        // ),

        for (ReviewModel _reviewModel in _reviews)
          _reviewUsers[_reviewModel.userID] == null
              ? Container()
              : ReviewWidget(
                  comment: _reviewModel.review,
                  image:
                      NetworkImage(_reviewUsers[_reviewModel.userID].profPic),
                  name: _reviewUsers[_reviewModel.userID].profileName,
                  initHeartValue: _reviewModel.likes,
                  isHeart: false,
                  lastday: DateTime.now()
                              .difference(
                                  DateTime.parse(_reviewModel.updatedAt))
                              .inHours >
                          24
                      ? DateTime.now()
                          .difference(DateTime.parse(_reviewModel.updatedAt))
                          .inDays
                      : DateTime.now()
                          .difference(DateTime.parse(_reviewModel.updatedAt))
                          .inHours,
                  showRatingbar: false,
                  initRating: _reviewModel.rate.toDouble(),
                ),
        SizedBox(
          height: 20,
        ),
        _reviews.length < 10
            ? Container()
            : Center(
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
      ],
    ));
  }
}
