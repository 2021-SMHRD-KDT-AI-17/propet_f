import 'package:flutter/material.dart';
import 'package:propetsor/mypage/mypage_update.dart';

class MainUser extends StatefulWidget {
  const MainUser();

  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  // 사용자의 반려동물 정보
  String petName = '멍멍이';
  String petBreed = '리트리버';
  int petAge = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          _buildPage(context),
          _buildPage(context),
          _buildPage(context), // 원하는 만큼 페이지를 추가할 수 있습니다.
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: 350,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCustomWidget(context),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 10),
            _buildCircleButton(context),
            SizedBox(height: 20),
            _buildPetInfo(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyPage()),
        // );
      },
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withOpacity(0.3))),
        child: ClipOval(
          child: Image.asset(
            'assets/images/logo2.png',
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildPetInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPetDetailBox('이름', petName),
          SizedBox(height: 10),
          _buildPetDetailBox('품종', petBreed),
          SizedBox(height: 10),
          _buildPetDetailBox('나이', '$petAge살'),
        ],
      ),
    );
  }

  Widget _buildPetDetailBox(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ProfileUpdate()),
        // );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.8)),
        ),
        child: Icon(
          Icons.edit,
          color: Colors.grey.withOpacity(0.8),
        ),
      ),
    );
  }
}

