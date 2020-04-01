import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/screens/login.dart';
import 'package:campsite/util/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupFormScreen extends StatefulWidget {
  @override
  _SignupFormScreenState createState() => _SignupFormScreenState();
}

class _SignupFormScreenState extends State<SignupFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  TextEditingController _txtName = TextEditingController();
  TextEditingController _txtVanName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  "HELLO !",
                  style:
                      TextStyle(color: Resources.mainBlackColor, fontSize: 25),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _txtName,
                          decoration: InputDecoration(
                              labelText: "Name*",
                              labelStyle:
                                  TextStyle(color: Resources.mainBlackColor)),
                          style: TextStyle(color: Resources.mainBlackColor),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _txtEmail,
                          decoration: InputDecoration(
                              labelText: "Email*",
                              labelStyle:
                                  TextStyle(color: Resources.mainBlackColor)),
                          style: TextStyle(color: Resources.mainBlackColor),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _txtVanName,
                          decoration: InputDecoration(
                              labelText: "Van Name",
                              labelStyle:
                                  TextStyle(color: Resources.mainBlackColor)),
                          style: TextStyle(color: Resources.mainBlackColor),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Van Name';
                            }
                            return null;
                          },
                        ),
                        // TextFormField(
                        //   decoration: InputDecoration(
                        //       labelText: "Traveller Status",
                        //       labelStyle:
                        //           TextStyle(color: Resources.mainBlackColor)),
                        //   style: TextStyle(color: Resources.mainBlackColor),
                        //   validator: (value) {
                        //     if (value.isEmpty) {
                        //       return 'Please Enter Traveller Status';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        TextFormField(
                          controller: _txtPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle:
                                  TextStyle(color: Resources.mainBlackColor)),
                          style: TextStyle(color: Resources.mainBlackColor),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle:
                                  TextStyle(color: Resources.mainBlackColor)),
                          style: TextStyle(color: Resources.mainBlackColor),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter same password';
                            } else if (value != _txtPassword.text) {
                              return 'Cannot Match with other.';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ButtonTheme(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  buttonColor: Colors.black87,
                                  minWidth: double.infinity,
                                  height: MediaQuery.of(context).size.height *
                                      0.075,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        FirebaseAuth _auth =
                                            FirebaseAuth.instance;
                                        _auth
                                            .createUserWithEmailAndPassword(
                                              email: _txtEmail.text,
                                              password: _txtPassword.text,
                                            )
                                            .then((value) => {
                                                  ProfileController()
                                                      .save(ProfileModel(
                                                          id: value.user.uid,
                                                          isVerified: false,
                                                          profileName:
                                                              _txtName.text,
                                                          vanName:
                                                              _txtVanName.text))
                                                      .then((value) => {
                                                            if (value.ok)
                                                              {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Account has created. PLease log in",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity: ToastGravity
                                                                        .BOTTOM,
                                                                    timeInSecForIos:
                                                                        1,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        16.0),
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                LoginScreen()))
                                                              }
                                                          }) // value.user
                                                })
                                            .catchError((e) {
                                          print(e);
                                          Fluttertoast.showToast(
                                              msg:
                                                  "There was an error. Please Try again.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIos: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Signup",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 30,
              right: 0,
              bottom: 30 + (sysHeight * 0.075 / 2) - 10,
              child: RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: "Already Onboard?\t",
                      style: TextStyle(color: Resources.mainBlackColor),
                    ),
                    TextSpan(
                        text: "Login",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                            print("LOGIN");
                          },
                        style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
