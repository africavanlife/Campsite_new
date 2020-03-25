import 'package:campsite/model/profile.dart';
import 'package:flutter/material.dart';

class AvatarList extends StatefulWidget {
  AvatarList(this.profileList);
  List<ProfileModel> profileList;

  @override
  _AvatarListState createState() => _AvatarListState();
}

class _AvatarListState extends State<AvatarList> {
  @override
  Widget build(BuildContext context) {
    int indx = 0;
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;

    double avatarRadius = sysWidth * 0.04;

    return Container(
      height: avatarRadius * 2,
      width: avatarRadius * (5 + 2),
      child: Stack(
        children: <Widget>[
          for (ProfileModel prof in widget.profileList)
            indx > 5
                ? Container()
                : Positioned(
                    top: 0,
                    left: avatarRadius * indx++,
                    child: Container(
                      width: avatarRadius * 2,
                      height: avatarRadius * 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(prof.profPic),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(
                          Radius.circular(avatarRadius),
                        ),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),

          // Positioned(
          //   top: 0,
          //   left: avatarRadius * 1,
          //   child: Container(
          //     width: avatarRadius * 2,
          //     height: avatarRadius * 2,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //           image: NetworkImage(
          //               "https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'"),
          //           fit: BoxFit.cover),
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(avatarRadius),
          //       ),
          //       border: Border.all(color: Colors.white, width: 2),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   left: avatarRadius * 2,
          //   child: Container(
          //     width: avatarRadius * 2,
          //     height: avatarRadius * 2,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //           image: NetworkImage(
          //               "https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'"),
          //           fit: BoxFit.cover),
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(avatarRadius),
          //       ),
          //       border: Border.all(color: Colors.white, width: 2),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   left: avatarRadius * 3,
          //   child: Container(
          //     width: avatarRadius * 2,
          //     height: avatarRadius * 2,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //           image: NetworkImage(
          //               "https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'"),
          //           fit: BoxFit.cover),
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(avatarRadius),
          //       ),
          //       border: Border.all(color: Colors.white, width: 2),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   left: avatarRadius * 4,
          //   child: Container(
          //     width: avatarRadius * 2,
          //     height: avatarRadius * 2,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //           image: NetworkImage(
          //               "https://img.traveltriangle.com/blog/wp-content/tr:w-700,h-400/uploads/2015/06/Demodara-Nine-Arch-Bridge.jpg'"),
          //           fit: BoxFit.cover),
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(avatarRadius),
          //       ),
          //       border: Border.all(color: Colors.white, width: 2),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
