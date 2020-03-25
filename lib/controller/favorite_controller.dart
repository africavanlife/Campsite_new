import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:campsite/controller/image_controller.dart';
import 'package:campsite/model/favourite.dart';
import 'package:campsite/resources/JsonToList.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/resources.dart';
import 'package:http/http.dart' as http;

class FavouriteController {
  Future<RequestResult> getAll() async {
    final uri = Uri.http(Resources.ip, '/favourite');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<FavouriteModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getByUser(String userID) async {
    final uri = Uri.http(Resources.ip, '/favourite/byUser/$userID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<FavouriteModel>(jsonDecode(response.body)).getList());
  }

   Future<RequestResult> getBySpot(String spotID) async {
    final uri = Uri.http(Resources.ip, '/favourite/bySpot/$spotID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<FavouriteModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> save(FavouriteModel data) async {
    final uri = Uri.http(Resources.ip, '/favourite');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return RequestResult(
        true, CreateList<FavouriteModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> update(String userID, List spotID) async {
    FavouriteModel _favouriteModel = FavouriteModel(spotID: spotID, userID: userID);

    final uri = Uri.http(Resources.ip, '/favourite/$userID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(_favouriteModel));
    return RequestResult(
        true, CreateList<FavouriteModel>(jsonDecode(response.body)).getList());
  }
}
