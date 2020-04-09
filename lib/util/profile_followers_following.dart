import 'package:campsite/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:campsite/util/resources.dart';

class ProfileFollowingFollower extends StatefulWidget {
  ProfileFollowingFollower(this.profiles);
  List<ProfileModel> profiles;
  // String profiles;
  @override
  _ProfileFollowingFollowerState createState() =>
      _ProfileFollowingFollowerState();
}

class _ProfileFollowingFollowerState extends State<ProfileFollowingFollower> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.profiles.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: CircleAvatar(
                radius: 30,
                backgroundImage: (widget.profiles[index].profPic == null ||
                        widget.profiles[index].profPic == "")
                    ? AssetImage("assets/add_image.png")
                    : NetworkImage(widget.profiles[index].profPic)),
            title: Text(widget.profiles[index].profileName),
            onTap: () {
              Resources.navigationKey.currentState.pushNamed('/viewProfile',
                  arguments: widget.profiles[index].id);
            },
          );
        });
  }
}
