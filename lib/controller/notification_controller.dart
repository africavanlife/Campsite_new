import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:campsite/controller/image_controller.dart';
import 'package:campsite/model/notifications.dart';
import 'package:campsite/resources/JsonToList.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/resources.dart';
import 'package:http/http.dart' as http;

class NotificationsController {
  Future<RequestResult> getAll() async {
    final uri = Uri.http(Resources.ip, '/notification');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
     if (response.body.length == 4 ||
        response.body == "" ||
        response.body == "null" ||
        response.body == null) {
      print("AAAAAAAAAAAAAA  ::" + response.body);
      return RequestResult(true, []);
    } else {
    return RequestResult(
        true, CreateList<NotificationsModel>(jsonDecode(response.body)).getList());
    }
  }

  Future<RequestResult> getByUser(String userID) async {
    final uri = Uri.http(Resources.ip, '/notification/byUser/$userID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
     if (response.body.length == 4 ||
        response.body == "" ||
        response.body == "null" ||
        response.body == null) {
      print("AAAAAAAAAAAAAA  ::" + response.body);
      return RequestResult(true, []);
    } else {
    return RequestResult(
        true, CreateList<NotificationsModel>(jsonDecode(response.body)).getList());
    }
  }


  Future<RequestResult> save(NotificationsModel data) async {
    final uri = Uri.http(Resources.ip, '/notification');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return RequestResult(
        true, CreateList<NotificationsModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> update(String userID, List notifications) async {
    NotificationsModel _notificationsModel = NotificationsModel(notifications: notifications, userID: userID);

    final uri = Uri.http(Resources.ip, '/notification/$userID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(_notificationsModel));
    return RequestResult(
        true, CreateList<NotificationsModel>(jsonDecode(response.body)).getList());
  }
}
