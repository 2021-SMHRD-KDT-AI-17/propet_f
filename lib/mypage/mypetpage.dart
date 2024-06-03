import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:propetsor/main.dart';
import 'package:propetsor/mypage/pet_edit.dart';
import 'package:propetsor/mypage/pet_enroll.dart';

import '../model/Pet.dart';

class MyPetPage extends StatefulWidget {
  const MyPetPage({Key? key}) : super(key: key);

  @override
  _MyPetPageState createState() => _MyPetPageState();
}

class _MyPetPageState extends State<MyPetPage> {
  List<Map<String, String>> pets = []; // 등록된 펫 목록을 저장할 리스트
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
    print(res);

    setState(() {
      pets = petModelFromJson(res.data.toString());
    });
  }



  void _addPet(Map<String, String> pet) {
    setState(() {
      pets.add(pet);
    });
  }

  void _editPet(int index, Map<String, String> pet) {
    setState(() {
      pets[index] = pet;
    });
  }

  void _deletePet(int index) {
    void deletePet() async{
      final dio = Dio();
      print("--------------------");
      print(pets[index]["pidx"]);
      Response res = await dio.post(
          "http://10.0.2.2:8089/boot/deletePet",
          data: {"p_idx" : pets[index]["pidx"]}
      );
    }

    setState(() {
      deletePet();
      pets.removeAt(index);
    });
  }

  Future<String?> _getUsername() async {
    String? username = await storage.read(key: 'uname');
    print('Username from storage: $username'); // 값 출력
    return username;
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
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  FutureBuilder<String?>(
                    future: _getUsername(),
                    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return Text(
                          snapshot.hasData ? "'${snapshot.data}'님 안녕하세요!" : '사용자 이름을 불러올 수 없습니다.',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  _PetRegistrationCard(onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PetEnroll(onEnroll: _addPet)),
                    );
                  }),
                  const SizedBox(height: 16),
                  pets.isNotEmpty
                      ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(bottom: 16),
                  )
                      : Container(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        final pet = pets[index];
                        return _PetInfoCard(
                          pet: pet,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetEdit(
                                  petData: pet,
                                  onEdit: (editedPet) => _editPet(index, editedPet),
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                            _deletePet(index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/back.jpg'), // 이미지 파일 경로로 변경
          fit: BoxFit.cover, // 이미지가 컨테이너를 채우도록 설정
        ),
      ),
    );
  }
}

class _PetRegistrationCard extends StatelessWidget {
  final VoidCallback onTap;

  const _PetRegistrationCard({Key? key, required this.onTap}) : super(key: key);

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
                '등록하기',
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

class _PetInfoCard extends StatelessWidget {
  final Map<String, String> pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PetInfoCard({
    Key? key,
    required this.pet,
    required this.onEdit,
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
              child: Icon(Icons.pets, color: Colors.deepPurpleAccent), // 아이콘 색깔을 퍼플로 설정
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
                            '이름',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '나이',
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
                            pet['pname'] != null && pet['pname']!.length > 6
                                ? pet['pname']!.substring(0, 6)
                                : pet['pname'] ?? '',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[800]), // 강조된 스타일
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            pet['page'] != null && pet['page']!.length > 2
                                ? pet['page']!.substring(0, 2)
                                : pet['page'] ?? '',
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
              icon: Icon(Icons.edit),
              onPressed: onEdit,
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
