import 'dart:convert';
import 'dart:io';
import 'package:campsite/resources/JsonToList.dart';
import 'package:campsite/model/review.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/resources.dart';
import 'package:http/http.dart' as http;

class ReviewController {
  Future<RequestResult> getAll() async {
    final uri = Uri.http(Resources.ip, '/review');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<ReviewModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getAllBySpot(String spotID) async {
    final uri = Uri.http(Resources.ip, '/review/bySpot/$spotID');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<ReviewModel>(jsonDecode(response.body)).getList());
  }

  Future<int> getReviewBySpotId(String spotId) async {
    final uri = Uri.http(Resources.ip, 'review/bySpot/avgRate/$spotId');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    int rate = jsonDecode(response.body)["avgRating"];

    print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLL" + rate.toString());
    // return jsonDecode(response.body)[0]["avgRating"];
    return rate;
  }

  Future<RequestResult> save([dynamic data]) async {
    final uri = Uri.http(Resources.ip, '/review');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return RequestResult(
        true, CreateList<ReviewModel>(jsonDecode(response.body)).getList());
  }
}
