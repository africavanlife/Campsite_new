import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:campsite/controller/image_controller.dart';
import 'package:campsite/model/event.dart';
import 'package:campsite/resources/JsonToList.dart';
import 'package:campsite/resources/RequestResult.dart';
import 'package:campsite/util/resources.dart';
import 'package:http/http.dart' as http;

class EventController {
  Future<RequestResult> getAll() async {
    final uri = Uri.http(Resources.ip, '/event');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<EventModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> filterByEvent(List eventTypes, int dateoffset) async {
    print(eventTypes.first);
    final uri = Uri.http(Resources.ip, '/event/filterByEvent');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(uri,
        headers: headers,
        body: jsonEncode({"eventTypes": eventTypes, "dateoffset": dateoffset}));

    return RequestResult(
        true, CreateList<EventModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> getById(String id) async {
    final uri = Uri.http(Resources.ip, '/event/$id');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    return RequestResult(
        true, CreateList<EventModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> save(Uint8List images, String imgTypes,
      [dynamic data]) async {
    print(data);
    String imgUrls = "";
    var url = await ImageController().save(imgTypes, images);
    imgUrls = (url);

    EventModel _eventModel = data;
    _eventModel.images = imgUrls;

    final uri = Uri.http(Resources.ip, '/event');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(_eventModel));
    return RequestResult(
        true, CreateList<EventModel>(jsonDecode(response.body)).getList());
  }

  Future<RequestResult> update(String id, dynamic data,
      {String imgTypes, Uint8List imgs}) async {
    EventModel _eventModel = data[0];
    String imgUrls = "";
    var url = await ImageController().save(imgTypes, imgs);
    imgUrls = (url);
    _eventModel.images = url;

    final uri = Uri.http(Resources.ip, '/event/$id');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return RequestResult(
        true, CreateList<EventModel>(jsonDecode(response.body)).getList());
  }
}
