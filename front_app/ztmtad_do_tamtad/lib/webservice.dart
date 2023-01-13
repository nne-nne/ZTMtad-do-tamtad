import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class WebService {
  static int bodyIndex = 0;
  static int responseIndex = 1;

  static Future<String> stopsRequest() async {
    final response = await http.get(Uri.parse(
        "https://ckan.multimediagdansk.pl/dataset/c24aa637-3619-4dc2-a171-a23eec8f2172/resource/4c4025f0-01bf-41f7-a39f-d156d201b82b/download/stops.json"));
    if (response.statusCode == HttpStatus.ok) {
      return utf8.decode(response.bodyBytes);
    } else {
      return 'Error in stops request';
    }
  }

  static Future<String> homeRequest() async {
    final response = await http.get(Uri.parse("http://localhost:8000/"));
    if (response.statusCode == HttpStatus.ok) {
      return response.body;
    } else {
      return 'Error in home request';
    }
  }

  static Future<String> pathsRequest() async {
    final response = await http.get(Uri.parse("http://localhost:8000/paths"));
    if (response.statusCode == HttpStatus.ok) {
      return response.body;
    } else {
      return 'Error in home request';
    }
  }
}
