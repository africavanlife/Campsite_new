import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:campsite/controller/image_controller.dart';
import 'package:campsite/model/checkin.dart';
import 'package:campsite/resources/JsonToList.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/resources.dart';
import 'package:http/http.dart' as http;

class CheckinController {
  Future<RequestResult> getAll() async {
    final uri = Uri.http(Resources.ip, '/checkin');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<CheckinModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getByUser(String userID) async {
    final uri = Uri.http(Resources.ip, '/checkin/byUser/$userID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<CheckinModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getBySpot(String spotId) async {
    final uri = Uri.http(Resources.ip, '/checkin/bySpot/$spotId');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    print("PGGGGGGGGGGGGGGGGGG  :"+response.body);
    return RequestResult(
        true, CreateList<CheckinModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> save(CheckinModel data) async {
    final uri = Uri.http(Resources.ip, '/checkin');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return RequestResult(
        true, CreateList<CheckinModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> update(String spotID, List userIds) async {
    CheckinModel _checkinModel = CheckinModel(spotID: spotID, userIDs: userIds);

    final uri = Uri.http(Resources.ip, '/checkin/$spotID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(_checkinModel));
    return RequestResult(
        true, CreateList<CheckinModel>(jsonDecode(response.body)).getList());
  }
}
