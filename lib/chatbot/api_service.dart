import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:propetsor/main.dart';
import 'package:provider/provider.dart';

class APIService {
  Future<String> sendMessage(String choose, String message, String breed, String age) async {
    String? uidx = await storage.read(key:"uidx");
    String u_idx;

    if (uidx != null){
      u_idx = uidx;
    }else{
      u_idx = "1";
    }

    final response = await http.post(
      Uri.parse('http://192.168.219.49:5001/chat'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'choose':choose,
        'query': message,
        'breed': breed,
        'age': age,
        'uidx': u_idx,
      }),
    );
    print("답변 보냄------------------------------------");
    print(response);
    if (response.statusCode == 200) {
      print("respon------------------------------------");
      print(response.body);
      return jsonDecode(response.body)['response'];
    } else {
      throw Exception('Failed to load response');
    }

    print (response.body);
  }
}
