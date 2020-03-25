import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/screens/allInOne.dart';
import 'package:campsite/screens/community.dart';
import 'package:campsite/screens/main_content.dart';
import 'package:campsite/screens/map_home.dart';
import 'package:campsite/screens/profile.dart';
import 'package:campsite/util/resources.dart';
import 'package:flutter/material.dart';
import 'package:bmnav/bmnav.dart' as bmnav;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  ProfileModel _profileModel;
  void getUserDetails(String userId) async {
    RequestResult result = await ProfileController().getById(userId);
    if (result.ok) {
      setState(() {
        _profileModel = result.data.first;
        print(_profileModel);
      });
    }
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Resources.mainWhiteColor,
        key: _drawerKey,
        drawer: Drawer(
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  color: Resources.mainWhiteColor,
                  width: sysWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(_profileModel == null
                            ? 'https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'
                            : _profileModel.profPic),
                        radius: 70,
                      ),
                      Container(
                        width: sysWidth * 0.5,
                        child: ButtonTheme(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Resources.mainColor,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          buttonColor: Resources.mainWhiteColor,
                          minWidth: double.infinity,
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text(
                              "EDIT PROFILE PHOTO",
                              style: TextStyle(
                                  color: Resources.mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FlatButton(
                          onPressed: () {},
                          child: Text(
                            "EDIT PROFILE",
                            style: TextStyle(color: Resources.mainColor),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                          onPressed: () {},
                          child: Text(
                            "INVITE FRIENDS",
                            style: TextStyle(color: Resources.mainColor),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                          onPressed: () {},
                          child: Text(
                            "CONTACT US",
                            style: TextStyle(color: Resources.mainColor),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                          onPressed: () {},
                          child: Text(
                            "LINKED ACCOUNT",
                            style: TextStyle(color: Resources.mainColor),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Resources.isVerified
                          ? Center(
                              child: Image.asset(
                              "assets/verifiedBadge.png",
                              width: sysWidth * 0.4,
                            ))
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ButtonTheme(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                buttonColor: Colors.red,
                                minWidth: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: RaisedButton(
                                  onPressed: () {
                                    Resources.navigationKey.currentState
                                        .pushNamed("/editProfile");
                                  },
                                  child: Text(
                                    "VERIFY",
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
              ),
              Positioned(
                bottom: 10,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {},
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        )),
                    FlatButton(
                        onPressed: () {},
                        child: Text(
                          "Legal Notice",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        // body: _currentScreen,
        body: MainContent(_drawerKey),
        bottomNavigationBar: bmnav.BottomNav(
          color: Resources.bottomNaviColor,
          index: 0,
          labelStyle: bmnav.LabelStyle(
            visible: true,
            onSelectTextStyle: TextStyle(color: Colors.red),
          ),
          onTap: (i) {
            setState(() {
              // _currentScreen = _screens[i];
              switch (i) {
                case 0:
                  Resources.navigationKey.currentState.pushNamed("/mapHome");
                  break;
                case 1:
                  Resources.navigationKey.currentState.pushNamed("/allInOne");
                  break;
                case 2:
                  Resources.navigationKey.currentState.pushNamed("/community");
                  break;
                case 3:
                  Resources.navigationKey.currentState.pushNamed("/profile");
                  break;
                default:
                  Resources.navigationKey.currentState.pushNamed("/");
              }
            });
          },
          iconStyle: bmnav.IconStyle(
            onSelectColor: Colors.red,
          ),
          items: [
            bmnav.BottomNavItem(
              IconData(0xe903, fontFamily: 'navIcons'),
              label: "Map",
            ),
            bmnav.BottomNavItem(IconData(0xe901, fontFamily: 'navIcons'),
                label: "All in One"),
            bmnav.BottomNavItem(IconData(0xe900, fontFamily: 'navIcons'),
                label: "Community"),
            bmnav.BottomNavItem(IconData(0xe902, fontFamily: 'navIcons'),
                label: "Profile")
          ],
        ),
      ),
    );
  }
}
