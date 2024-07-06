import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000/';

  fetchMusic(String morning, String afternoon, String evening) async {
    try {
      final Map<String, String> body = {
        'morning': morning,
        'afternoon': afternoon,
        'evening': evening,
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        body: json.encode(body),
        headers: <String, String> {
          'Content-Type': 'application/json',
        }
      );

      if(response.statusCode == 200) {

        return APIResponse(
          success: true,
          errorMessage: "",
        );
      } else {
        return APIResponse(
            success: false,
            errorMessage: 'Failed to fetch music. Status code: ${response.statusCode}',
        );
      }
    } catch(e) {
      return APIResponse(
        data: null,
        success: false,
        errorMessage: 'Error : ${e.toString()}',
      );
    }
  }
}

class APIResponse<T> {
  final T? data;
  final bool success;
  final String errorMessage;

  APIResponse({this.data, this.success = true, required this.errorMessage});
}