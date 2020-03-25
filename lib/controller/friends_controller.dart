import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:campsite/controller/image_controller.dart';
import 'package:campsite/model/friends.dart';
import 'package:campsite/resources/JsonToList.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/resources.dart';
import 'package:http/http.dart' as http;

class FriendsController {
  Future<RequestResult> getAll() async {
    final uri = Uri.http(Resources.ip, '/friends');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<FriendsModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getByUser(String userID) async {
    final uri = Uri.http(Resources.ip, '/friends/byUser/$userID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<FriendsModel>(jsonDecode(response.body)).getList());
  }

   Future<RequestResult> getByFriend(String userID) async {
    final uri = Uri.http(Resources.ip, '/friends/byFriend/$userID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<FriendsModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> save(FriendsModel data) async {
    final uri = Uri.http(Resources.ip, '/friends');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return RequestResult(
        true, CreateList<FriendsModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> update(String userID, List friends) async {
    FriendsModel _friendsModel = FriendsModel(friends: friends, userID: userID);

    final uri = Uri.http(Resources.ip, '/friends/$userID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(_friendsModel));
    return RequestResult(
        true, CreateList<FriendsModel>(jsonDecode(response.body)).getList());
  }
}
