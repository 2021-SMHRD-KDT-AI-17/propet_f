import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  String _botResponse = '';
  String? _breed;
  String? _age;
  String _currentStep = 'initial';

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'bot',
      'message': '안녕하세요! 프로펫서 입니다! 질문을 입력해주세요.',
      'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
      'name': '프로펫서',
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
          'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
          'name': 'User',
        });
        _controller.clear();
        _focusNode.unfocus();
      });

      switch (_currentStep) {
        case 'initial':
          setState(() {
            _currentStep = 'awaiting_breed';
          });
          _addBotMessage('견종을 입력해주세요.');
          break;
        case 'awaiting_breed':
          setState(() {
            _breed = message;
            _currentStep = 'awaiting_age';
          });
          _addBotMessage('나이를 입력해주세요.');
          break;
        case 'awaiting_age':
          setState(() {
            _age = message;
            _currentStep = 'awaiting_message';
          });
          _isWaitingForResponse = true;
          _botResponse = '';

          try {
            String response = await widget.apiService.sendMessage(message, _breed!, _age!);
            response = response.replaceAll(RegExp(r'- (참조|출처)\s*:\s*.*$|wiki'), '').trim();

            setState(() {
              _botResponse = response;
              _isWaitingForResponse = false;
              _messages.add({
                'role': 'bot',
                'message': _botResponse,
                'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
                'name': '프로펫서',
              });
              _botResponse = '';
            });
          } catch (e) {
            setState(() {
              _isWaitingForResponse = false;
            });
          }
          break;
      }
    }
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add({
        'role': 'bot',
        'message': message,
        'timestamp': DateFormat('hh:mm a').format(DateTime.now()),
        'name': '프로펫서',
      });
    });
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
                    fontSize: 14,
                    fontFamily: 'Geekble',
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
                    fontFamily: 'Omyu',
                    color: isUserMessage ? Colors.white : Colors.black,
                    fontSize: 18,
                  ),
                )
                    : AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      formattedMessage,
                      textStyle: TextStyle(
                        fontFamily: 'Omyu',
                        color: Colors.black,
                        fontSize: 18,
                      ),
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
                    fontFamily: 'Omyu',
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
            SizedBox(height: 10),
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
                      '잠시만 기다려주세요..!!',
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Omyu',
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  repeatForever: true,
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
                          fontFamily: 'Omyu',
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.grey,
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
