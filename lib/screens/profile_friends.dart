import 'package:campsite/controller/profile_controller.dart';
import 'package:campsite/util/profile_followers_following.dart';
import 'package:flutter/material.dart';
import 'package:tabbar/tabbar.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/controller/friends_controller.dart';
import 'package:campsite/util/resources.dart';

class ProfileFriends extends StatefulWidget {
  @override
  _ProfileFriendsState createState() => _ProfileFriendsState();
}

class _ProfileFriendsState extends State<ProfileFriends> {
  bool _dataloaded = false;
  final controller = TabbarController();
  List<ProfileModel> _followers = List();
  List<ProfileModel> _followings = List();

  getDetails() async {
    var lst1 = List<ProfileModel>();
    var lst2 = List<ProfileModel>();
   await FriendsController().getByUser(Resources.userId).then((req) async => {
          req.data.forEach((friendlist) {
            friendlist.friends.forEach((id) {
              ProfileController().getById(id).then((value) => {
                    lst1.add(value.data[0]),
                  });
            });
          }),


        await  FriendsController().getByFriend(Resources.userId).then((requ) => {
          requ.data.forEach((friendli) {
            friendli.friends.forEach((id) {
              ProfileController().getById(id).then((value) => {
                    lst2.add(value.data[0]),
                  });
            });
          }),

          
        }),
         setState(() {
      _followers = lst1;
      _followings = lst2;
      _dataloaded = true;
    }),
    print("GGGGGGGGGGGGGGGGGG" +
        _followers.length.toString() +
        " : " +
        _followings.length.toString()),

        });
    // var req = (await FriendsController().getByUser(Resources.userId));
    // var requ = (await FriendsController().getByFriend(Resources.userId));
    // var lst1 = List<ProfileModel>();
    // req.data.forEach((friendlist) {
    //   friendlist.friends.forEach((id) async {
    //     lst1.add((await ProfileController().getById(id)).data[0]);
    //   });
    // });

    // var lst2 = List<ProfileModel>();
    // requ.data.forEach((friendlist) {
    //   friendlist.friends.forEach((id) async {
    //     lst2.add((await ProfileController().getById(id)).data[0]);
    //   });
    // });

   
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabbarHeader(
            controller: controller,
            tabs: [
              Tab(text: "Folowings"),
              Tab(text: "Followers"),
            ],
          ),
        ),
      ),
      body: _dataloaded
          ? TabbarContent(
              controller: controller,
              children: <Widget>[
                ProfileFollowingFollower(_followers),
                ProfileFollowingFollower(_followings),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
