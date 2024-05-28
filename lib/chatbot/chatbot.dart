import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'api_service.dart';

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
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 처음에 초기 메시지를 추가합니다.
    _messages.add({
      'role': 'bot',
      'message': '안녕하세요! 저는 프로펫서 입니다! 무엇을 도와드릴까요?',
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
      String sentMessage = 'Sent message: $message';
      setState(() {
        _messages.add({'role': 'user', 'message': message});
        _isWaitingForResponse = true;
        _controller.clear();
        // 키보드 감추기
        _focusNode.unfocus();
      });

      try {
        String response = await widget.apiService.sendMessage(message);
        // 정규식을 사용하여 - 참조 또는 - 출처가 포함된 부분을 삭제하고 마지막에 있는 개행 제거(wiki 포함)
        response = response.replaceAll(RegExp(r'- (참조|출처)\s*:\s*.*$|wiki'), '').trim();

        setState(() {
          _messages.add({'role': 'bot', 'message': response});
          _isWaitingForResponse = false;
        });
      } catch (e) {
        setState(() {
          _messages.add({'role': 'bot', 'message': 'Failed to get response'});
          _isWaitingForResponse = false;
        });
      }
    }
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUserMessage = message['role'] == 'user';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //------------------------------------------------------------------------사용자
          if (isUserMessage) // 사용자 메시지인 경우
            SizedBox(width: 40),
          if (isUserMessage) // 사용자 메시지인 경우
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message['message']!,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (isUserMessage) // 사용자 메시지인 경우
            SizedBox(width: 8),
          if (isUserMessage) // 사용자 메시지인 경우
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/nanda.jpg'),
              radius: 20,
            ),

          //------------------------------------------------------------------------챗봇
          if (!isUserMessage) // 봇 메시지인 경우
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/nanda.jpg'),
              radius: 20,
            ),
          if (!isUserMessage) // 봇 메시지인 경우
            SizedBox(width: 8),
          if (!isUserMessage) // 봇 메시지인 경우
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message['message']!,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          if (!isUserMessage) // 사용자 메시지인 경우
            SizedBox(width: 40),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
            if (_isWaitingForResponse)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '답변을 기다리는 중...!',
                  style: TextStyle(fontStyle: FontStyle.italic),
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
                      onSubmitted: (_) => _sendMessage(), // 엔터 키를 눌렀을 때 _sendMessage 함수 호출
                      decoration: InputDecoration(
                        hintText: '질문을 입력해주세요!',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _sendMessage,
                    child: Text('Send'),
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
