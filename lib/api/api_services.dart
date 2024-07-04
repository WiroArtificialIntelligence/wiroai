import 'package:http/http.dart' as http;
import 'dart:convert';
import 'musicgen_request.dart';

class APIServices {
  Future<http.Response> fetchMusic(String description) async {
    var request = MusicGenRequest();
    var url = Uri.parse(
        request.url + '?description=' + Uri.encodeComponent(description));
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    return response;
  }
}
