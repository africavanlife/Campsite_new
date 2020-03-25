import 'package:campsite/controller/spot_controller.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/util/spot_detail.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/model/review.dart';

class AddNewSpotFill extends StatefulWidget {
  @override
  _AddNewSpotFillState createState() => _AddNewSpotFillState();
}

class _AddNewSpotFillState extends State<AddNewSpotFill> {
  ReviewModel _reviewModel = ReviewModel();
  bool _progressBar = false;
  @override
  void initState() {
    // Map args = ModalRoute.of(context).settings.arguments as Map;
    // _spotModal = args['spotModel'];
    // _images = args['images'];
    // _imageTypes = args['imgTypes'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments as Map;
    SpotModel _spotModal = args['spotModel'];
    List _images = args['images'];
    List _imageTypes = args['imgTypes'];

    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return _progressBar
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SpotDetails(
                  show: false,
                  spotModel: _spotModal,
                  onSpotChange: (spotModel) {
                    setState(() {
                      _spotModal = spotModel;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Did you love this Place?"),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    RatingBar(
                      maxRating: 5,
                      onRatingChanged: (rating) {
                        print(rating);
                        setState(() {
                          _reviewModel.rate = rating.toInt();
                        });
                      },
                      filledIcon: FontAwesomeIcons.solidCircle,
                      emptyIcon: FontAwesomeIcons.solidCircle,
                      isHalfAllowed: false,
                      filledColor: Resources.mainColor,
                      emptyColor: Colors.grey,
                      size: 48,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Tag this Post"),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: <Widget>[
                    TagWidget(
                      "We never want to leave",
                      onClicked: (status) {},
                    ),
                    TagWidget(
                      "Fun for kids",
                      onClicked: (status) {},
                    ),
                    TagWidget(
                      "Isolated",
                      onClicked: (status) {},
                    ),
                    TagWidget(
                      "Great Stargazing",
                      onClicked: (status) {},
                    ),
                    TagWidget(
                      "Just Overnight",
                      onClicked: (status) {},
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Add Review : "),
                  onChanged: (value) {
                    setState(() {
                      _reviewModel.review = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width: sysWidth * 0.5,
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      buttonColor: Colors.red,
                      minWidth: double.infinity,
                      height: sysHeight * 0.05,
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            _progressBar = true;
                          });
                          SpotController().save(_images, _imageTypes,
                              [_spotModal, _reviewModel]).then((value) {
                            if (value.ok) {
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
                        },
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class TagWidget extends StatefulWidget {
  TagWidget(this.text, {this.onClicked, this.show = false});
  final String text;
  Function(bool status) onClicked;
  final bool show;
  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  bool _selected = false;
  Color clr = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: RaisedButton(
        onPressed: () {
          if (!widget.show) {
            print(_selected);
            setState(() {
              if (_selected) {
                clr = Colors.grey;
              } else {
                clr = Resources.mainColor;
              }
              // _selected ? Colors.grey : Resources.mainColor;
              _selected = !_selected;
              // clr == Resources.mainColor ? clr = Colors.grey : Resources.mainColor;
              widget.onClicked(_selected);
            });
          }
        },
        child: Text(
          widget.text,
          style: TextStyle(color: clr),
        ),
        color: Resources.mainWhiteColor,
        shape: RoundedRectangleBorder(side: BorderSide(color: clr, width: 1)),
      ),
    );
  }
}
