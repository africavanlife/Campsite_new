import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:campsite/util/resources.dart';
import 'package:http/http.dart' as http;

class ImageController {
  Future save(String imgType, Uint8List data) async {
    final uri = Uri.http(Resources.ip, '/img/imageBuffer');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    final response = await http.post(uri,
        headers: headers,
        body: jsonEncode({"img": base64Encode(data), "imgType": imgType}));
 
    return (jsonDecode(response.body)["location"]);
  }
}
