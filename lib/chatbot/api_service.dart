import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:propetsor/config/config.dart';
import 'package:propetsor/main.dart';
import 'package:provider/provider.dart';

class APIService {
  Future<String> sendMessage(String choose, String message, String breed, String age) async {
    String? uidx = await storage.read(key: "uidx");
    String u_idx = uidx ?? "1";

    print("메서드 실행은 됨ㅋ-------------------------------");

    try {
      final response = await http.post(
        Uri.parse('${Config.chatUrl}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'choose': choose,
          'query': message,
          'breed': breed,
          'age': age,
          'uidx': u_idx,
        }),
      ).timeout(Duration(seconds: 30));  // 타임아웃 설정

      print("*-*-*-*-*-*-*-*-*-*-*-*-");
      print(response.body);

      if (response.statusCode == 200) {
        // JSON 응답을 문자열로 변환
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse; // 서버에서 "response" 키에 해당하는 값을 반환
      } else {
        throw Exception('Failed to load response with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load response: $e');
    }
  }
}
