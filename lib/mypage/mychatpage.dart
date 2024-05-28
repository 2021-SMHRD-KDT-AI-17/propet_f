import 'package:flutter/material.dart';
import 'package:propetsor/chatbot/chatbot.dart';
import 'package:propetsor/mainPage/main_2.dart';

class MyChatPage extends StatefulWidget {
  const MyChatPage({Key? key}) : super(key: key);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  final List<Map<String, String>> chats = []; // 대화 목록을 저장할 리스트

  void _addChat(Map<String, String> chat) {
    setState(() {
      chats.add(chat);
    });
  }

  void _editChat(int index, Map<String, String> chat) {
    setState(() {
      chats[index] = chat;
    });
  }

  void _deleteChat(int index) {
    setState(() {
      chats.removeAt(index);
    });
  }

  void _navigateToChatBotPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage_2(initialIndex: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
            title: GestureDetector(
              onTap: () {
                // 메인 페이지로 이동
              },
              child: Container(
                height: 30,
                width: 120,
                child: Image.asset(
                  'assets/images/logo3.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      // 알림 아이콘 클릭 시 동작
                    },
                  ),
                  Positioned(
                    right: 11,
                    top: 11,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "'조세핀'님의 대화 목록",
              style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.0,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            _ChatRegistrationCard(onTap: () {
              _navigateToChatBotPage(context);
            }),
            const SizedBox(height: 16),
            chats.isNotEmpty
                ? Container(
              width: MediaQuery.of(context).size.width,
              height: 1.0,
              color: Colors.grey,
              margin: const EdgeInsets.only(bottom: 16),
            )
                : Container(),
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return _ChatInfoCard(
                    chat: chat,
                    onView: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(
                            chatData: chat,
                          ),
                        ),
                      );
                    },
                    onDelete: () {
                      _deleteChat(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatRegistrationCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ChatRegistrationCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white, // 박스 내부 색깔을 하얀색으로 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // 높이 증가
          child: Row(
            children: [
              Container(
                width: 48, // 아이콘이 들어가는 원의 크기
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey), // 회색 테두리 추가
                  color: Colors.white, // 배경을 흰색으로 설정
                ),
                child: Icon(Icons.add, color: Colors.deepPurpleAccent), // 아이콘 색깔을 퍼플로 설정
              ),
              const Spacer(),
              Text(
                '새 대화 시작하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatInfoCard extends StatelessWidget {
  final Map<String, String> chat;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const _ChatInfoCard({
    Key? key,
    required this.chat,
    required this.onView,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), // 높이 증가
        child: Row(
          children: [
            Container(
              width: 48, // 아이콘이 들어가는 원의 크기
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey), // 회색 테두리 추가
                color: Colors.white, // 배경을 흰색으로 설정
              ),
              child: Icon(Icons.chat, color: Colors.deepPurpleAccent), // 아이콘 색깔을 퍼플로 설정
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '대화 제목',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '날짜',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            chat['title'] ?? '',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[800]), // 강조된 스타일
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            chat['date'] ?? '',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.visibility),
              onPressed: onView,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatDetailPage extends StatelessWidget {
  final Map<String, String> chatData;

  const ChatDetailPage({Key? key, required this.chatData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대화 내용'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatData['title'] ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              chatData['date'] ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              chatData['content'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBotPage extends StatelessWidget {
  final Function(Map<String, String>) onAddChat;

  const ChatBotPage({Key? key, required this.onAddChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Bot'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 예제 대화 데이터
            final chatData = {
              'title': '새로운 대화',
              'date': '2024-05-28',
              'content': '이것은 예제 대화 내용입니다.',
            };
            onAddChat(chatData);
            Navigator.pop(context);
          },
          child: Text('대화 추가'),
        ),
      ),
    );
  }
}