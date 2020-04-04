import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/screens/profile.dart';
import 'package:campsite/util/resources.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _profPic;
  File _coverPic;
  Uint8List img;
  final _formKey = GlobalKey<FormState>();
  List<String> _travellerStatus = [
    "Full Time",
    "Part Time",
    "Dreamer",
    "Rental"
  ];
  bool _progressBarActive = true;

  TextEditingController _txtProfileName = TextEditingController();
  TextEditingController _txtCountry = TextEditingController();
  TextEditingController _txtAbout = TextEditingController();
  TextEditingController _txtVanName = TextEditingController();
  TextEditingController _txtVehicleType = TextEditingController();
  TextEditingController _txtInstaAcc = TextEditingController();
  TextEditingController _txtWhatsappAcc = TextEditingController();

  ProfileModel _profileModel = ProfileModel();
  ProfileController _profileController = ProfileController();
  void getUserDetails(String userId) async {
    RequestResult result = await _profileController.getById(userId);
    if (result.ok) {
      setState(() {
        _profileModel = result.data.first;
        _txtProfileName.text = _profileModel.profileName;
        _txtCountry.text = _profileModel.country;
        _txtAbout.text = _profileModel.aboutUs;
        _txtVanName.text = _profileModel.vanName;
        _txtVehicleType.text = _profileModel.vehicleType;
        _txtInstaAcc.text = _profileModel.instaAcc;
        _txtWhatsappAcc.text = _profileModel.whatsappAcc;
        _progressBarActive = false;
        print(_profileModel);
      });
    }
  }

  Future getProfImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _profPic = image;
    });
  }

  Future getCoverImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image);
    setState(() {
      _coverPic = image;
    });
  }

  @override
  void initState() {
    getUserDetails(Resources.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                    _coverPic != null
                                        ? Image(
                                            width: sysWidth,
                                            height: sysHeight * 0.3,
                                            image: FileImage(_coverPic),
                                            fit: BoxFit.cover,
                                          )
                                        : (_profileModel.coverPic != null &&
                                                _profileModel.coverPic != "")
                                            ? Image(
                                                width: sysWidth,
                                                height: sysHeight * 0.3,
                                                image: NetworkImage(
                                                    _profileModel.coverPic),
                                                fit: BoxFit.cover,
                                              )
                                            : Image(
                                                width: sysWidth,
                                                height: sysHeight * 0.3,
                                                image: AssetImage(
                                                    'assets/add_image.png'),
                                                fit: BoxFit.cover,
                                              ),
                                    Positioned(
                                      bottom: sysHeight * 0.02,
                                      left: 20,
                                      child: CircleAvatar(
                                        backgroundImage: _profPic != null
                                            ? FileImage(_profPic)
                                            : (_profileModel.profPic != null &&
                                                    _profileModel.profPic != "")
                                                ? NetworkImage(
                                                    _profileModel.profPic)
                                                : AssetImage(
                                                    'assets/add_image.png'),
                                        radius: sysHeight * 0.07,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 20,
                                      child: Container(
                                        height: sysHeight * 0.017,
                                        width: sysHeight * 0.14,
                                        child: ButtonTheme(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Resources.mainColor,
                                              style: BorderStyle.solid,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          buttonColor: Resources.mainWhiteColor,
                                          minWidth: double.infinity,
                                          child: RaisedButton(
                                            onPressed: () {
                                              getProfImage();
                                            },
                                            child: Text(
                                              "EDIT PROFILE",
                                              style: TextStyle(
                                                  color: Resources.mainColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: sysHeight * 0.1,
                                      right: 10,
                                      child: Container(
                                        width: sysWidth * 0.4,
                                        height: sysHeight * 0.025,
                                        child: ButtonTheme(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.grey,
                                              style: BorderStyle.solid,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          buttonColor: Colors.transparent,
                                          minWidth: double.infinity,
                                          child: RaisedButton(
                                            onPressed: () {
                                              getCoverImage();
                                            },
                                            child: Text(
                                              "EDIT YOUR VAN PHOTO",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: TextFormField(
                                              controller: _txtProfileName,
                                              decoration: InputDecoration(
                                                  labelText: "Profile Name"),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  // return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _txtCountry,
                                              decoration: InputDecoration(
                                                  labelText: "Country"),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  // return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _txtAbout,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                            labelText: "About Me"),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            // return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: TextFormField(
                                              controller: _txtVanName,
                                              decoration: InputDecoration(
                                                  labelText: "Van Name"),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  // return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _txtVehicleType,
                                              decoration: InputDecoration(
                                                  labelText: "Vehicle Type"),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  // return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: TextFormField(
                                              controller: _txtInstaAcc,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      "Instagram Account"),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  // return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _txtWhatsappAcc,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      "Whatsapp Account"),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  // return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      DropdownButtonFormField(
                                          value: _profileModel.travStatus,
                                          validator: (value) {
                                            if (value == null) {
                                              // return 'Please Select Category';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              labelText: "Traveller Status"),
                                          items: _travellerStatus.map(
                                            (category) {
                                              return DropdownMenuItem(
                                                child: Text(category),
                                                value: category,
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _profileModel.travStatus = value;
                                            });
                                          }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        // child: RaisedButton(
                                        //   onPressed: () {
                                        //     if (_formKey.currentState.validate()) {}
                                        //   },
                                        //   child: Text('Submit'),
                                        // ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 50),
                                          child: ButtonTheme(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            buttonColor: Resources.mainColor,
                                            minWidth: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.075,
                                            child: RaisedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  _profileModel.profileName =
                                                      _txtProfileName.text;
                                                  _profileModel.country =
                                                      _txtCountry.text;
                                                  _profileModel.aboutUs =
                                                      _txtAbout.text;
                                                  _profileModel.vanName =
                                                      _txtVanName.text;
                                                  _profileModel.vehicleType =
                                                      _txtVehicleType.text;
                                                  _profileModel.instaAcc =
                                                      _txtInstaAcc.text;
                                                  _profileModel.whatsappAcc =
                                                      _txtWhatsappAcc.text;
                                                });

                                                _profileController
                                                    .update(
                                                        _profileModel.id,
                                                        _profileModel,
                                                        _profPic,
                                                        _coverPic)
                                                    .then((value) {
                                                  if (value.ok) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Succeddfully Updated",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIos: 1,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProfileScreen()));
                                                  }
                                                });
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
                                  ),
                                ),
                              )
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
