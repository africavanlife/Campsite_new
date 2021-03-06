import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/screens/home.dart';
import 'package:campsite/screens/signup_home.dart';
import 'package:campsite/util/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();

  setLogin(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userID', id);
  }

  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    bool _progressBarActive = false;
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
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.png"),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // Image.asset(
                        //   "assets/logo.png",
                        //   width: 100,
                        // ),
                        Text(
                          "WELCOME",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        SizedBox(height: 70),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Login With",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Image.asset(
                                      "assets/fb_icon.png",
                                      width: sysWidth * 0.15,
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        _progressBarActive=true;
                                      });
                                      print("SSS");
                                      final facebookLogin = FacebookLogin();
                                      final result =
                                          await facebookLogin.logIn(['email']);

                                      print(result.accessToken.token);
                                      FirebaseAuth.instance
                                          .signInWithCredential(
                                              FacebookAuthProvider
                                                  .getCredential(
                                                      accessToken: result
                                                          .accessToken.token))
                                          .then((value) => {
                                                print(value.user.uid),
                                                ProfileController()
                                                    .getById(value.user.uid)
                                                    .then((data) => {
                                                          if (data.data.length >
                                                              0)
                                                            {
                                                              setState(() {
                                                                _progressBarActive=false;
                                                                Resources
                                                                        .userId =
                                                                    value.user
                                                                        .uid;
                                                                setLogin(value
                                                                    .user.uid);
                                                              }),
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              HomeScreen()))
                                                            }
                                                          else
                                                            {
                                                              ProfileController()
                                                                  .save(
                                                                      ProfileModel(
                                                                    id: value
                                                                        .user
                                                                        .uid,
                                                                    profileName:
                                                                        value
                                                                            .user
                                                                            .displayName,
                                                                    profPic: value
                                                                        .user
                                                                        .photoUrl,
                                                                    isVerified:
                                                                        false,
                                                                  ))
                                                                  .then(
                                                                      (saved) =>
                                                                          {
                                                                            setState(() {
                                                                              _progressBarActive=false;
                                                                              Resources.userId = value.user.uid;
                                                                            }),
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (context) => HomeScreen()))
                                                                          })
                                                            }
                                                        })
                                              });
                                    },
                                  ),
                                  GestureDetector(
                                    child: Image.asset(
                                      "assets/google_icon.jpg",
                                      width: sysWidth * 0.15,
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        _progressBarActive=true;
                                      });
                                      // GoogleSignIn().signIn().then((data) => {
                                      //       data.authentication
                                      //           .then((value) => {print(value.idToken)})
                                      //     });
                                      print("SSS");
                                      final result =
                                          await GoogleSignIn().signIn();

                                      // print((await result.authentication).idToken);
                                      FirebaseAuth.instance
                                          .signInWithCredential(
                                              GoogleAuthProvider.getCredential(
                                                  idToken: (await result
                                                          .authentication)
                                                      .idToken,
                                                  accessToken: (await result
                                                          .authentication)
                                                      .accessToken))
                                          .then((value) => {
                                                print(value.user.uid),
                                                ProfileController()
                                                    .getById(value.user.uid)
                                                    .then((data) => {
                                                          if (data.data.length >
                                                              0)
                                                            {
                                                              setState(() {
                                                                _progressBarActive=false;
                                                                Resources
                                                                        .userId =
                                                                    value.user
                                                                        .uid;
                                                                setLogin(value
                                                                    .user.uid);
                                                              }),
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              HomeScreen()))
                                                            }
                                                          else
                                                            {
                                                              ProfileController()
                                                                  .save(
                                                                      ProfileModel(
                                                                    id: value
                                                                        .user
                                                                        .uid,
                                                                    profileName:
                                                                        value
                                                                            .user
                                                                            .displayName,
                                                                    profPic: value
                                                                        .user
                                                                        .photoUrl,
                                                                    isVerified:
                                                                        false,
                                                                  ))
                                                                  .then(
                                                                      (saved) =>
                                                                          {
                                                                            setState(() {
                                                                              _progressBarActive=false;
                                                                              Resources.userId = value.user.uid;
                                                                            }),
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (context) => HomeScreen()))
                                                                          })
                                                            }
                                                        })
                                              });
                                    },
                                  ),
                                  GestureDetector(
                                    child: Image.asset(
                                      "assets/insta_logo.png",
                                      width: sysWidth * 0.15,
                                    ),
                                    onTap: () {
                                      _progressBarActive=true;
                                      print("SSS");

                                      simpleAuth.InstagramApi(
                                              "instagram",
                                              "515236689420399",
                                              "208f43abcddd356c02f511b30377cacf",
                                              "https://africavanlife-5613d.firebaseapp.com/__/auth/handler",
                                              scopes: ['user_profile'])
                                          .authenticate()
                                          .then((value) => {
                                                print(
                                                    value.toJson()['user_id']),
                                                print(value.toJson()['token']),
                                                ProfileController()
                                                    .getById(value
                                                        .toJson()['user_id']
                                                        .toString())
                                                    .then((data) => {
                                                          if (data.data.length >
                                                              0)
                                                            {
                                                              setState(() {
                                                                _progressBarActive=false;
                                                                setLogin(value
                                                                    .toJson()[
                                                                        'user_id']
                                                                    .toString());
                                                                Resources.userId = value
                                                                    .toJson()[
                                                                        'user_id']
                                                                    .toString();
                                                              }),
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              HomeScreen()))
                                                            }
                                                          else
                                                            {
                                                              ProfileController()
                                                                  .save(
                                                                      ProfileModel(
                                                                    id: value
                                                                        .toJson()[
                                                                            'user_id']
                                                                        .toString(),
                                                                    isVerified:
                                                                        false,
                                                                  ))
                                                                  .then(
                                                                      (saved) =>
                                                                          {
                                                                            setState(() {
                                                                              _progressBarActive=false;
                                                                              Resources.userId = value.toJson()['user_id'].toString();
                                                                              setLogin(value.toJson()['user_id'].toString());
                                                                            }),
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (context) => HomeScreen()))
                                                                          })
                                                            }
                                                        })
                                              })
                                          // {print("PPPPPPPPPPPPPP    :    " + value.userData)})
                                          .catchError((e) => {print(e)});
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(children: <Widget>[
                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "OR",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: _txtEmail,
                                decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: Colors.white)),
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: _txtPassword,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: Colors.white)),
                                obscureText: true,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 50),
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
                                      _progressBarActive=true;
                                      FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: _txtEmail.text,
                                              password: _txtPassword.text)
                                          .then((value) => {
                                            _progressBarActive=false,
                                                Resources.userId =
                                                    value.user.uid,
                                                setLogin(value.user.uid),
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen()))
                                              })
                                          .catchError((e) {
                                        print(e);
                                        Fluttertoast.showToast(
                                            msg: "No Such Account",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIos: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      });

                                      // final FirebaseUser user =
                                      //     (await _auth.createUserWithEmailAndPassword(
                                      //   email: "abcd@gmail.com",
                                      //   password: "123456",
                                      // ))
                                      //         .user;
                                      // print(user.uid);

                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => HomeScreen()));
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 100),
                            ],
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
                            TextSpan(text: "Need an Account?\t"),
                            TextSpan(
                                text: "Sign Up",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignupHomeScreen()));
                                    print("SIGN UP");
                                  },
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
