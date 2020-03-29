import 'dart:typed_data';

import 'package:campsite/controller/spot_controller.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/util/image_picker.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/util/spot_detail.dart';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditSpotScreen extends StatefulWidget {
  EditSpotScreen(this.spotModel);
  SpotModel spotModel;
  @override
  _EditSpotScreenState createState() => _EditSpotScreenState();
}

class _EditSpotScreenState extends State<EditSpotScreen> {
  List<Uint8List> images = List<Uint8List>();
  String _error;
  bool enableCarousal = false;

  List<String> _imageTypes = List();

loadAssets(){
    ImagePickerClass(context, (img, imageTypes) {
      _imageTypes.addAll(imageTypes);
      images.addAll(img);
      setState(() {
          enableCarousal = images.length > 0;
      images = images;
      });
      // setPrint(images.length > 0);
    });
  }

  void updateData() {
    setState(() {
      _progressBar = false;
    });
    SpotController()
        .update(widget.spotModel.spotId, widget.spotModel,
            imgs: images, imgTypes: _imageTypes)
        .then((value) {
      if (value.ok) {
        Fluttertoast.showToast(
            msg: "Succeddfully Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        setState(() {
          _progressBar = false;
        });
        Resources.navigationKey.currentState.pushReplacementNamed("/");
      }
    });
  }

  bool _progressBar = false;
  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height - 50;
    double sysWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _progressBar
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Container(
                  width: sysWidth,
                  height: sysHeight * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Resources.mainBlackColor),
                        ),
                        onTap: () {
                          // Navigator.pop(context);
                          if (Resources.navigationKey.currentState.canPop()) {
                            Resources.navigationKey.currentState.pop();
                          }
                        },
                      ),
                      Text(
                        "EDIT SPOT",
                        style: TextStyle(color: Resources.mainBlackColor),
                      ),
                      GestureDetector(
                        child: Text(
                          "SAVE",
                          style: TextStyle(color: Resources.mainColor),
                        ),
                        onTap: () {
                          updateData();
                        },
                      ),
                    ],
                  ),
                  color: Resources.mainWhiteColor,
                ),
                Container(
                  width: sysWidth,
                  height: sysHeight * 0.9,
                  child: Stack(
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
                                children: <Widget>[
                                  SizedBox(
                                    width: sysWidth,
                                    height: sysHeight * 0.3,
                                    child: Stack(
                                      children: <Widget>[
                                        enableCarousal
                                            ? Carousel(
                                                boxFit: BoxFit.cover,
                                                autoplay: false,
                                                animationCurve:
                                                    Curves.fastOutSlowIn,
                                                animationDuration: Duration(
                                                    milliseconds: 1000),
                                                dotSize: 6.0,
                                                dotIncreasedColor: Colors.green,
                                                dotBgColor: Colors.black38,
                                                dotPosition:
                                                    DotPosition.bottomCenter,
                                                showIndicator: true,
                                                indicatorBgPadding: 7.0,
                                                images: [
                                                  for (Uint8List img in images)
                                                    MemoryImage(img)
                                                ],
                                              )
                                            : GestureDetector(
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/add_image.png"),
                                                  width: sysWidth,
                                                  height: sysHeight * 0.3,
                                                  fit: BoxFit.cover,
                                                ),
                                                onTap: () async {
                                                  loadAssets();
                                                },
                                              ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SpotDetails(
                                          spotModel: widget.spotModel,
                                          show: false,
                                          onSpotChange: (spotModel) {
                                            setState(() {
                                              widget.spotModel = spotModel;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),

                                        // child: Container(),
                                        child: Container(
                                          width: sysWidth * 0.4,
                                          child: ButtonTheme(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            buttonColor: Colors.red,
                                            minWidth: double.infinity,
                                            height: sysHeight * 0.05,
                                            child: RaisedButton(
                                              onPressed: () {
                                                // SpotController()
                                                //     .update(widget.spotModel.spotId,
                                                //         widget.spotModel)
                                                //     .then((value) {
                                                //   if (value.ok) {
                                                //     Fluttertoast.showToast(
                                                //         msg: "Succeddfully Updated",
                                                //         toastLength:
                                                //             Toast.LENGTH_SHORT,
                                                //         gravity: ToastGravity.BOTTOM,
                                                //         timeInSecForIos: 1,
                                                //         backgroundColor: Colors.red,
                                                //         textColor: Colors.white,
                                                //         fontSize: 16.0);
                                                //     Resources
                                                //         .navigationKey.currentState
                                                //         .pushReplacementNamed("/");
                                                //   }
                                                // });
                                                updateData();
                                              },
                                              child: Text(
                                                "SAVE",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
