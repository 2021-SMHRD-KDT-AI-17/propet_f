import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:propetsor/main.dart';
import 'package:propetsor/model/Pet.dart';

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
      "http://211.48.213.165:8089/boot/selectAllPet",
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
      body: PageView(
        children: pets.map((pet) {
          String petName = pet['pname'] as String;
          String petBreed = pet['pkind'] as String;
          int petAge = int.tryParse(pet['page'].toString()) ?? 0;
          return _buildPage(context, petName, petBreed, petAge);
        }).toList(),
      ),
    );
  }

  Widget _buildPage(BuildContext context, String petName, String petBreed, int petAge) {
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
            _buildPetInfo(petName, petBreed, petAge),
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

  Widget _buildPetInfo(String petName, String petBreed, int petAge) {
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
