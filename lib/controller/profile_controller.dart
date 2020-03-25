import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:campsite/controller/image_controller.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/resources/JsonToList.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/resources.dart';
import 'package:http/http.dart' as http;

class ProfileController {
  Future<RequestResult> getAll() async {
    final uri = Uri.http(Resources.ip, '/profile');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<ProfileModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> save([dynamic data]) async {
    final uri = Uri.http(Resources.ip, '/profile');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return RequestResult(
        true, CreateList<ProfileModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> update(
      String id, ProfileModel data, File profPic, File coverPic) async {
    if (profPic != null) {
      var url = await ImageController().save(
          (profPic.uri.toString())
              .split(".")[(profPic.uri.toString()).split(".").length - 1],
          Uint8List.fromList(profPic.readAsBytesSync()));
      data.profPic = url;
    } else {
      data.profPic = "";
    }

    if (coverPic != null) {
      var url = await ImageController().save(
          (coverPic.uri.toString())
              .split(".")[(coverPic.uri.toString()).split(".").length - 1],
          Uint8List.fromList(coverPic.readAsBytesSync()));
      data.coverPic = url;
    } else {
      data.coverPic = "";
    }

    final uri = Uri.http(Resources.ip, '/profile/$id');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return RequestResult(
        true, CreateList<ProfileModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getById(String id) async {
    final uri = Uri.http(Resources.ip, '/profile/$id');
    // final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri);
    print(response);
    return RequestResult(
        true, CreateList<ProfileModel>(jsonDecode(response.body)).getList());
  }
}
