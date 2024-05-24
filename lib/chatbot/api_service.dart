import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('http://211.48.213.165:5000/chat'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'query': message,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    } else {
      throw Exception('Failed to load response');
    }
  }
}
