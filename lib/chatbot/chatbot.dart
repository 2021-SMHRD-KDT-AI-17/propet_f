import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'api_service.dart';
import 'package:intl/intl.dart'; // 시간 포맷을 위해 사용
import 'package:animated_text_kit/animated_text_kit.dart'; // animated_text_kit 패키지 추가

class ChatScreen extends StatefulWidget {
  final APIService apiService;

  ChatScreen({required this.apiService});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isWaitingForResponse = false;
  String _botResponse = ''; // 챗봇의 응답을 저장하는 변수

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'bot',
      'message': '안녕하세요! 프로펫서 입니다!',
      'timestamp': DateFormat('hh:mm a').format(DateTime.now()), // 초기 메시지의 시간 추가
      'name': '프로펫서' // 봇의 이름
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({
          'role': 'user',
          'message': message,
          'timestamp': DateFormat('hh:mm a').format(DateTime.now()), // 사용자가 보낸 메시지의 시간 추가
          'name': 'User' // 사용자의 이름
        });
        _isWaitingForResponse = true;
        _botResponse = ''; // 챗봇의 응답 초기화
        _controller.clear();
        _focusNode.unfocus();
      });

      try {
        String response = await widget.apiService.sendMessage(message);
        response = response.replaceAll(RegExp(r'- (참조|출처)\s*:\s*.*$|wiki'), '').trim();

        setState(() {
          _botResponse = response;
          _isWaitingForResponse = false;
        });
      } catch (e) {
        setState(() {
          _isWaitingForResponse = false;
        });
      }
    }
  }

  String _formatMessage(String message) {
    final int maxCharsPerLine = 20;
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < message.length; i += maxCharsPerLine) {
      buffer.writeln(message.substring(i, i + maxCharsPerLine > message.length ? message.length : i + maxCharsPerLine));
    }

    return buffer.toString().trim();
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUserMessage = message['role'] == 'user';
    bool isFirstMessage = message == _messages.first;
    String formattedMessage = _formatMessage(message['message']!);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUserMessage)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              backgroundImage: AssetImage('assets/images/logo2.png'),
              radius: 20,
            ),
          ),
        Flexible(
          child: Column(
            crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  message['name']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUserMessage ? Colors.deepPurple[300] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isFirstMessage || isUserMessage
                    ? Text(
                  formattedMessage,
                  style: TextStyle(
                    color: isUserMessage ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                )
                    : AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      formattedMessage,
                      textStyle: TextStyle(color: Colors.black, fontSize: 16),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  message['timestamp']!,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isUserMessage)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              backgroundImage: AssetImage('assets/images/user_avatar.png'),
              radius: 20,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10), // 첫 멘트 위에 여백 추가
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: _buildMessage(_messages[index]),
                  );
                },
              ),
            ),
            if (_isWaitingForResponse)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      '잠시만 기다려주세요..!',
                      textStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  repeatForever: true, // 애니메이션을 무한 반복
                ),
              ),
            if (_botResponse.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      _botResponse,
                      textStyle: TextStyle(color: Colors.black, fontSize: 16),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                  onFinished: () {
                    setState(() {
                      _messages.add({
                        'role': 'bot',
                        'message': _botResponse,
                        'timestamp': DateFormat('hh:mm a').format(DateTime.now()), // 봇이 보낸 메시지의 시간 추가
                        'name': '프로펫서' // 봇의 이름
                      });
                      _botResponse = '';
                    });
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: '프로펫서에게 지금 바로 질문해 보세요!',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.underline, // 밑줄 추가
                          decorationColor: Colors.grey, // 밑줄 색상 설정
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
