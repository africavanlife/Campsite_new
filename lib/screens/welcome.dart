import 'package:campsite/screens/home.dart';
import 'package:campsite/screens/login.dart';
import 'package:campsite/util/resources.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Resources.setIcons();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                Text(
                  "Welcome to Campsite",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Minim exercitation eiusmod nulla voluptate exercitation. Velit ex veniam fugiat elit sit enim eiusmod. Magna quis nulla culpa cupidatat id anim id ad adipisicing est adipisicing do ex. Nisi id do laborum reprehenderit eu veniam culpa mollit. Commodo est et aliqua reprehenderit dolore ut voluptate nulla anim in excepteur minim.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Opacity(
                  opacity: 0.2,
                  child: ButtonTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    buttonColor: Colors.white,
                    minWidth: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.075,
                    child: RaisedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String userID = prefs.getString('userID');
                        if (userID != null && userID != "") {
                          setState(() {
                            Resources.userId = userID;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        }
                      },
                      // child: Text(
                      //   "Get Started",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom:
                  30 + (MediaQuery.of(context).size.height * 0.075 / 2) - 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Get Started",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
