import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerClass {
  List<Uint8List> images = List<Uint8List>();
  List<String> imageTypes = List();

  BuildContext context;
  Function(List<Uint8List> images, List<String> imageTypes) onSelect;
  ImagePickerClass(this.context, this.onSelect) {
    showDialog(
      context: this.context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                child: Image.asset(
                  'assets/pick_camera.png',
                  width: 50,
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  File croppedFile = await ImageCropper.cropImage(
                      sourcePath: image.path,
                      aspectRatioPresets: [
                        CropAspectRatioPreset.square,
                      ],
                      androidUiSettings: AndroidUiSettings(
                          toolbarTitle: 'Cropper',
                          toolbarColor: Colors.red,
                          toolbarWidgetColor: Colors.white,
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: true),
                      iosUiSettings: IOSUiSettings(
                          minimumAspectRatio: 1.0,
                          aspectRatioLockEnabled: true));

                  images.add(croppedFile.readAsBytesSync());
                  imageTypes.add(croppedFile.path.split(".").last);
                  onSelect(images, imageTypes);
                },
              ),
              GestureDetector(
                child: Image.asset(
                  'assets/pick_gallery.png',
                  width: 50,
                ),
                onTap: () async {
                  // Navigator.of(context).pop();

                  Navigator.of(context).pop();
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  File croppedFile = await ImageCropper.cropImage(
                      sourcePath: image.path,
                      aspectRatioPresets: [
                        CropAspectRatioPreset.square,
                      ],
                      androidUiSettings: AndroidUiSettings(
                          toolbarTitle: 'Cropper',
                          toolbarColor: Colors.red,
                          toolbarWidgetColor: Colors.white,
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: true),
                      iosUiSettings: IOSUiSettings(
                          minimumAspectRatio: 1.0,
                          aspectRatioLockEnabled: true));

                  images.add(croppedFile.readAsBytesSync());
                  imageTypes.add(croppedFile.path.split(".").last);
                  onSelect(images, imageTypes);

                  // List<Asset> resultList;

                  // try {
                  //   resultList = await MultiImagePicker.pickImages(
                  //     maxImages: 300,
                  //   );

                  //   for (Asset asset in resultList) {
                  //     imageTypes.add(asset.name.split(".").last);
                  //     images.add(
                  //         (await asset.getByteData()).buffer.asUint8List());
                  //   }
                  // } on Exception catch (e) {
                  //   print(e.toString());
                  // }
                  // onSelect(images, imageTypes);
                },
              )
            ],
          ),
        );
      },
    );

    // Alert alert = Alert(
    //     style: AlertStyle(
    //       // buttonAreaPadding: EdgeInsets.all(0),
    //       animationType: AnimationType.fromTop,
    //       isCloseButton: false,
    //       isOverlayTapDismiss: false,
    //       backgroundColor: Colors.white,
    //       descStyle: TextStyle(fontWeight: FontWeight.bold),
    //       animationDuration: Duration(milliseconds: 400),
    //       alertBorder: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(50),
    //         side: BorderSide(
    //           color: Colors.grey,
    //         ),
    //       ),
    //       titleStyle: TextStyle(
    //         color: Colors.red,
    //       ),
    //     ),
    //     context: this.context,
    //     title: "Image Chooser",
    //     content: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: <Widget>[
    //         GestureDetector(
    //           child: Image.asset(
    //             'assets/pick_camera.png',
    //             width: 50,
    //           ),
    //           onTap: () async {
    //             var image =
    //                 await ImagePicker.pickImage(source: ImageSource.camera);
    //             images.add(image.readAsBytesSync());
    //             imageTypes.add(image.path.split(".").last);
    //             onSelect(images, imageTypes);
    //           },
    //         ),
    //         GestureDetector(
    //           child: Image.asset(
    //             'assets/pick_gallery.png',
    //             width: 50,
    //           ),
    //           onTap: () async {
    //             List<Asset> resultList;

    //             try {
    //               resultList = await MultiImagePicker.pickImages(
    //                 maxImages: 300,
    //               );

    //               for (Asset asset in resultList) {
    //                 imageTypes.add(asset.name.split(".").last);
    //                 images
    //                     .add((await asset.getByteData()).buffer.asUint8List());
    //                 // ass = (await asset.getByteData()).buffer;
    //               }
    //             } on Exception catch (e) {
    //               print(e.toString());
    //             }
    //             onSelect(images, imageTypes);
    //           },
    //         )
    //       ],
    //     ),
    //     buttons: []);

    // alert.show();
    // print(ModalRoute);
  }
}
