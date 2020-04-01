import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/screens/home.dart';
import 'package:campsite/screens/login.dart';
import 'package:campsite/screens/signup_form.dart';
import 'package:campsite/util/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class SignupHomeScreen extends StatefulWidget {
  @override
  _SignupHomeScreenState createState() => _SignupHomeScreenState();
}

class _SignupHomeScreenState extends State<SignupHomeScreen> {
  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.cover)),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image.asset(
                  "assets/logo.png",
                  width: 100,
                ),
                Text(
                  "Campsite",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Get Started With",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: Image.asset(
                              "assets/fb_icon.png",
                              width: sysWidth * 0.2,
                            ),
                            onTap: () async {
                              print("SSS");
                              final facebookLogin = FacebookLogin();
                              final result =
                                  await facebookLogin.logIn(['email']);

                              print(result.accessToken.token);
                              FirebaseAuth.instance
                                  .signInWithCredential(
                                      FacebookAuthProvider.getCredential(
                                          accessToken:
                                              result.accessToken.token))
                                  .then((value) => {
                                        print(value.user.uid),
                                        ProfileController()
                                            .getById(value.user.uid)
                                            .then((data) => {
                                                  if (data.data.length > 0)
                                                    {
                                                      Resources.userId =
                                                          value.user.uid,
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HomeScreen()))
                                                    }
                                                  else
                                                    {
                                                      ProfileController()
                                                          .save(ProfileModel(
                                                            id: value.user.uid,
                                                            profileName: value
                                                                .user
                                                                .displayName,
                                                            profPic: value
                                                                .user.photoUrl,
                                                            isVerified: false,
                                                          ))
                                                          .then((saved) => {
                                                                Resources
                                                                        .userId =
                                                                    value.user
                                                                        .uid,
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                HomeScreen()))
                                                              })
                                                    }
                                                })
                                      });
                            },
                          ),
                          GestureDetector(
                            child: Image.asset(
                              "assets/google_icon.jpg",
                              width: sysWidth * 0.2,
                            ),
                            onTap: () {
                              print("SSS");
                            },
                          ),
                          GestureDetector(
                            child: Image.asset(
                              "assets/insta_logo.png",
                              width: sysWidth * 0.2,
                            ),
                            onTap: () {
                              print("SSS");
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Or Signup With",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ButtonTheme(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          buttonColor: Colors.white,
                          minWidth: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.075,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignupFormScreen()));
                            },
                            child: Text(
                              "Email",
                              style: TextStyle(
                                  color: Colors.black,
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
                    TextSpan(text: "Already Onboard?\t"),
                    TextSpan(
                        text: "Login",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                            print("Login");
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
