import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:propetsor/main.dart';
import 'package:propetsor/model/Pet.dart';
import 'package:propetsor/mypage/mypetpage.dart';

class MainUser extends StatefulWidget {
  const MainUser();

  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  List<Map<String, String>> pets = []; // 등록된 펫 목록을 저장할 리스트

  @override
  void initState() {
    super.initState();
    // 페이지가 로드되기 전에 정보를 가져오는 작업
    _loadPets();
  }

  // JSON 문자열을 List<Map<String, String>>로 변환하는 함수
  List<Map<String, String>> petModelFromJson(String str) {
    final jsonData = json.decode(str) as List;
    return jsonData.map((e) => Pet.fromJson(e).toMap()).toList();
  }

  void _loadPets() async {
    final dio = Dio();

    String? uidx = await storage.read(key: 'uidx');

    Response res = await dio.post(
      "http://10.0.2.2:8089/boot/selectAllPet",
      data: {"uidx": uidx},
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    setState(() {
      pets = petModelFromJson(res.data.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pets.isEmpty
          ? _buildNoPetsPage(context)
          : PageView(
        children: [
          ...pets.map((pet) {
            String petName = pet['pname'] as String;
            String petBreed = pet['pkind'] as String;
            int petAge = int.tryParse(pet['page'].toString()) ?? 0;
            String petGender = pet['pgender'] as String;
            String petWeight = pet['pkg'] as String;
            return _buildPage(
                context, petName, petBreed, petAge, petGender, petWeight);
          }).toList(),
          if (pets.length < 3) _buildAddPetPage(context),
        ],
      ),
    );
  }

  Widget _buildNoPetsPage(BuildContext context) {
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPetPage()),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.pets,
                  size: 80,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '등록된 펫이 없습니다.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.withOpacity(1.0),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '지금 바로 사랑스러운 펫을 등록해 보세요!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 30),
            _buildRegisterButton(context, '마이 펫 등록'),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, String petName, String petBreed,
      int petAge, String petGender, String petWeight) {
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
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 5),
            _buildCircleButton(context),
            SizedBox(height: 1),
            _buildPetInfo(petName, petBreed, petAge, petGender, petWeight),
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
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
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

  Widget _buildPetInfo(String petName, String petBreed, int petAge,
      String petGender, String petWeight) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _buildPetDetailBox(Icons.drive_file_rename_outline, '이름', petName, Colors.deepPurpleAccent.shade100)),
              SizedBox(width: 10),
              Expanded(child: _buildPetDetailBox(Icons.pets, '품종', petBreed, Colors.brown.shade200)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildPetDetailBox(Icons.cake, '나이', '$petAge살', Colors.orangeAccent.shade100)),
              SizedBox(width: 10),
              Expanded(child: _buildPetDetailBox(
                petGender == '수컷' ? Icons.male : Icons.female,
                '성별',
                petGender,
                petGender == '수컷' ? Colors.blueAccent.shade100 : Colors.pinkAccent.shade100,
              )),
              SizedBox(width: 10),
              Expanded(child: _buildPetDetailBox(Icons.monitor_weight, '몸무게', '$petWeight kg', Colors.green.shade200)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetDetailBox(IconData icon, String title, String value, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
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
      child: Column(
        children: [
          Icon(icon, size: 24, color: iconColor),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPetPage(BuildContext context) {
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPetPage()),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  size: 80,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '마이 펫 추가 등록하기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.withOpacity(1.0),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '최대 3마리까지 등록 가능합니다!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 20),
            _buildRegisterButton(context, '마이펫 등록'),
          ],
        ),
      ),
    );
  }


  Widget _buildRegisterButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyPetPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurpleAccent,
        shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24), // 패딩을 추가하여 버튼을 더 크고 터치하기 쉽게 만듭니다.
        minimumSize: Size(200, 50), // 버튼의 최소 크기를 설정합니다.
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 텍스트 길이에 따라 버튼 크기가 결정되도록 합니다.
        children: [
          Icon(Icons.favorite, size: 24), // 아이콘을 추가하여 버튼의 직관성을 높입니다.
          SizedBox(width: 8), // 아이콘과 텍스트 사이에 여백을 추가합니다.
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildCustomWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyPetPage()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
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
