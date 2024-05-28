import 'package:flutter/material.dart';
import 'package:propetsor/login/login.dart';
import 'package:propetsor/mainPage/main_1.dart'; // main_1.dart 파일 import 추가

class MainNon extends StatelessWidget {
  const MainNon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 500, // 박스의 높이 증가
          width: 350, // 박스의 너비 증가
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 4), // 그림자의 위치 조정
              ),
            ],
            borderRadius: BorderRadius.circular(20), // 박스의 모서리를 둥글게 조정
            border: Border.all(color: Colors.grey.withOpacity(0.3)), // 테두리 색상 및 너비 조정
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                '환영합니다!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage_1(initialIndex: 1), // 초기 인덱스를 1로 설정
                    ),
                  );
                },
                child: Text(
                  '프로펫서 챗봇 이용하러 가기!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6),
                    decoration: TextDecoration.underline, // 밑줄 추가
                  ),
                ),
              ),
              SizedBox(height: 30),
              _buildCircleButton(context),
              SizedBox(height: 30),
              _buildLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Container(
        width: 180, // 크기 조절 가능
        height: 180, // 크기 조절 가능
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepPurpleAccent, // 버튼 색상 설정
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 8,
              offset: Offset(0, 4), // 그림자의 위치 조정
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 50, // 추가 원의 크기 조절
                height: 50, // 추가 원의 크기 조절
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // 추가 원의 색상 설정
                  border: Border.all(color: Colors.grey), // 추가 원의 테두리 색상 설정
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
            ),
            Icon(
              Icons.add,
              size: 80, // 아이콘 크기 조절 가능
              color: Colors.white, // 아이콘 색상 설정
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40), // 좌우 마진 추가
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 8,
              offset: Offset(0, 4), // 그림자를 하단에만 나타나도록 설정
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login_rounded,
              color: Colors.white, // 아이콘 색상
              size: 24, // 아이콘 크기
            ),
            SizedBox(width: 10), // 아이콘과 텍스트 사이 간격 조정
            Text(
              '로그인 후 이용해 주세요.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // 텍스트 색상
              ),
            ),
          ],
        ),
      ),
    );
  }
}
