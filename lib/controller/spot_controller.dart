import 'dart:convert';
import 'dart:io';
import 'package:campsite/controller/image_controller.dart';
import 'package:campsite/model/SpotSeparate.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/model/review.dart';
import 'package:campsite/resources/JsonToList.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/resources.dart';
import 'package:campsite/controller/review_controller.dart';
import 'package:http/http.dart' as http;

class SpotController {
  Future<RequestResult> getAll() async {
    final uri = Uri.http(Resources.ip, '/spot');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<SpotModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getById(String id) async {
    final uri = Uri.http(Resources.ip, '/spot/getById/$id');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<SpotModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getSeparate() async {
    final uri = Uri.http(Resources.ip, '/spot/separate');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(true,
        CreateList<SpotSeparateModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getSeparateByUser(String userID) async {
    final uri = Uri.http(Resources.ip, '/spot/separateByUser/$userID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(true,
        CreateList<SpotSeparateModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getNearBy(int dist, double lat, double lang) async {
    final uri = Uri.http(Resources.ip, '/spot/near');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(uri,
        headers: headers,
        body: jsonEncode({"dist": dist, "lat": lat, "lang": lang}));

    return RequestResult(
        true, CreateList<SpotModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> filterBySpot(List spotTypes, SpotModel spotModel,
      double lat, double long, int dist) async {
    final uri = Uri.http(Resources.ip, '/spot/filterBySpot');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(uri,
        headers: headers,
        body: jsonEncode({
          "spotModel": spotModel,
          "spotTypes": spotTypes,
          "location": {"dist": dist, "lat": lat, "long": long}
        }));

    return RequestResult(
        true, CreateList<SpotModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> save(List images, List imgTypes, [dynamic data]) async {
    List imgUrls = List();
    for (int i = 0; i < images.length; i++) {
      var url = await ImageController().save(imgTypes[i], images[i]);
      imgUrls.add(url);
    }
    SpotModel _spotModel = data[0];
    _spotModel.images = imgUrls;

    final uri = Uri.http(Resources.ip, '/spot');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(_spotModel));

    if (response.statusCode == 200) {
      ReviewModel _reviewModel = ReviewModel(
        userID: jsonDecode(response.body)["userID"],
        spotID: jsonDecode(response.body)["_id"],
        likes: data[1].likes,
        rate: data[1].rate,
        review: data[1].review,
      );

      RequestResult reqRes = await ReviewController().save(_reviewModel);
      if (reqRes.ok) {
        return RequestResult(
            true, CreateList<SpotModel>(jsonDecode(response.body)).getList());
      } else {
        return RequestResult(false, [response.body]);
      }
      // return reqRes;
    } else {
      return RequestResult(false, [response.body]);
    }
  }

  Future<RequestResult> update(String id, dynamic data,
      {List imgTypes, List imgs}) async {
    List imgUrls = List();
    SpotModel _spotMode = data;
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   ${_spotMode.images.length}");
    if (imgs != null && imgs.length > 0) {
      for (int i = 0; i < imgs.length; i++) {
        var url = await ImageController().save(imgTypes[i], imgs[i]);
        imgUrls.add(url);
        _spotMode.images.add(url);
      }
    }

    print(
        "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB   ${_spotMode.images.length}");

    final uri = Uri.http(Resources.ip, '/spot/update/$id');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return RequestResult(
        true, CreateList<SpotModel>(jsonDecode(response.body)).getList());
  }
}
