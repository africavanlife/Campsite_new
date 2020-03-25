import 'package:campsite/util/icon_buttons.dart';
import 'package:campsite/util/resources.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rating_bar/rating_bar.dart';

class ReviewWidget extends StatefulWidget {
  ReviewWidget(
      {this.comment,
      this.image,
      this.initHeartValue,
      this.isHeart,
      this.lastday,
      this.name,
      this.showRatingbar,
      this.initRating});
  final bool showRatingbar;
  final String name;
  final ImageProvider image;
  final String comment;
  final int lastday;
  bool isHeart;
  int initHeartValue;
  final double initRating;
  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Container(
      width: sysWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: widget.image,
                  radius: 20,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(
                          color: Resources.mainBlackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    widget.showRatingbar
                        ? Row(
                            children: <Widget>[
                              RatingBar(
                                initialRating: widget.initRating,
                                maxRating: 5,
                                onRatingChanged: (rating) {},
                                filledIcon: FontAwesomeIcons.solidCircle,
                                emptyIcon: FontAwesomeIcons.solidCircle,
                                isHalfAllowed: false,
                                filledColor: Colors.red,
                                emptyColor: Colors.grey,
                                size: 10,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text("${widget.initRating}/5")
                            ],
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: sysWidth * 0.75,
                      child: Text(widget.comment),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: sysWidth * 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              AIconButtons(
                                false,
                                actImageUrl: "assets/heart_act.png",
                                inactImageUrl: "assets/heart_inact.png",
                                onTap: (value) {
                                  setState(() {
                                    value
                                        ? widget.initHeartValue++
                                        : widget.initHeartValue--;
                                  });
                                },
                                initAct: widget.isHeart,
                              ),
                              Text("${widget.initHeartValue}"),
                            ],
                          ),
                          Text("${widget.lastday} DAYS AGO"),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            Divider(),
           
          ],
        ),
      ),
    );
  }
}
