import 'package:campsite/screens/add_event.dart';
import 'package:campsite/screens/add_new_spot_fill.dart';
import 'package:campsite/screens/add_new_spot_map.dart';
import 'package:campsite/screens/allInOne.dart';
import 'package:campsite/screens/community.dart';
import 'package:campsite/screens/community_details.dart';
import 'package:campsite/screens/edit_profile.dart';
import 'package:campsite/screens/event_add_spot_fill.dart';
import 'package:campsite/screens/event_add_spot_map.dart';
import 'package:campsite/screens/map_home.dart';
import 'package:campsite/screens/profile.dart';
import 'package:campsite/screens/profile_friends.dart';
import 'package:campsite/screens/profile_view.dart';
import 'package:campsite/util/nested_route.dart';
import 'package:campsite/util/profile_followers_following.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/util/review.dart';
import 'package:flutter/material.dart';

class MainContent extends StatefulWidget {
  MainContent(this.drawerKey);
  final GlobalKey<ScaffoldState> drawerKey;
  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  void initState() {
    setState(() {
      Resources.context = context;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedNavigator(
      navigationKey: Resources.navigationKey,
      initialRoute: '/',
      routes: {
        '/': (context) => MapHomeScreen(widget.drawerKey),
        '/allInOne': (context) => AllInOneScreen(),
        // '/allInOne': (context) => ReviewWidget(),
        '/addSpotMap': (context) => AddNewSpotMap(),
        // '/eventAddSpotMap': (context) => EventAddNewSpotMap(),
        '/addSpotFill': (context) => AddNewSpotFill(),
        // '/eventAddSpotFill': (context) => EventAddNewSpotFill(),
        '/addEvent': (context) => AddEventScreen(),
        '/mapHome': (context) => MapHomeScreen(widget.drawerKey),
        '/profile': (context) => ProfileScreen(),
        '/editProfile': (context) => EditProfileScreen(),
        '/community': (context) => CommunityScreen(widget.drawerKey),
        '/communityDetails': (context) => CommunityDetailsScreen(),
        '/viewProfile': (context) => ProfileViewScreen(),
        '/viewProfileFriends': (context) => ProfileFriends(),
      },
    );
  }
}
