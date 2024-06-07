import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
  showNotification(message);
}

void showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id', // 알림 채널 ID
    'your_channel_name', // 알림 채널 이름
    importance: Importance.max, // 알림 중요도 설정
    priority: Priority.high, // 알림 우선도 설정
    ticker: 'ticker', // 티커 텍스트 설정
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  String? title = message.data['title'];
  String? body = message.data['body'];

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
    payload: 'mychatpage',
  );
}

// FCM 토큰과 u_idx를 서버에 전송하는 함수
// FCM 토큰과 u_idx를 서버에 전송하는 함수
Future<void> sendTokenToServer(String token, String uIdx) async {

  print("token : " + token);
  print("u_idx: " + uIdx);

  final url = Uri.parse('http://10.0.2.2:8089/boot/api/token');

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'token': token,
      'u_idx': int.parse(uIdx),
    }),
  );

  if (response.statusCode == 200) {
    print('Token sent to server successfully');
  } else {
    print('Failed to send token to server');
  }
}

