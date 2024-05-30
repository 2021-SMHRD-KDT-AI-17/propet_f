import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:propetsor/mainPage/main_2.dart';

class PetEnroll extends StatefulWidget {
  final Function(Map<String, String>) onEnroll;

  const PetEnroll({Key? key, required this.onEnroll}) : super(key: key);

  @override
  _PetEnrollState createState() => _PetEnrollState();
}

class _PetEnrollState extends State<PetEnroll> {
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  TextEditingController pnameCon = TextEditingController();
  TextEditingController pkindCon = TextEditingController();
  TextEditingController pageCon = TextEditingController();
  TextEditingController pkgCon = TextEditingController();
  TextEditingController pdiseaseinfCon = TextEditingController();

  final Map<String, String> _petData = {
    'pname': '',
    'page': '',
    'pgender': '',
    'pkind': '',
    'pkg': '',
    'psurgery': '',
    'pdisease': '',
    'pdiseaseinf': '',
  };

  bool _hasDisease = false;
  String? _selectedGender;
  String? _selectedNeutered;
  String? _selectedDisease;

  final Color selectedColor = Colors.deepPurpleAccent;
  final Color unselectedColor = Colors.grey[300]!;

  Future<void> enroll(Map<String, String> petData) async {
    final dio = Dio();

    try {
      Response res = await dio.post(
        'http://59.0.236.149:8089/boot/enroll',
        data: {'enrollPet': petData},
      );

      if (res.statusCode == 200) {
        print('Pet enrolled successfully!');
      } else {
        print('Failed to enroll pet. ${res.statusMessage}');
        throw Exception('Failed to enroll pet');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw e;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String? uidx = await _storage.read(key: 'uidx');

      if (uidx != null) {
        _petData['uidx'] = uidx;
        _petData['pname'] = pnameCon.text;
        _petData['page'] = pageCon.text;
        _petData['pkind'] = pkindCon.text;
        _petData['pkg'] = pkgCon.text;
        _petData['pdiseaseinf'] = pdiseaseinfCon.text;
        _petData['pgender'] = _selectedGender ?? '';
        _petData['psurgery'] = _selectedNeutered ?? '';
        _petData['pdisease'] = _selectedDisease ?? '';

        try {
          await enroll(_petData);
          widget.onEnroll(_petData);
          Navigator.pop(context);
        } catch (e) {
          print('Error during enrollment: $e');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to enroll pet. Please try again later.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('로그인 정보가 없습니다. 다시 로그인 해주세요.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // AppBar 높이 설정
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2), // 그림자의 위치 조정
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // 뒤로가기 동작
              },
            ),
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage_2()),
                );
              },
              child: Container(
                height: 30, // 이미지 높이
                width: 120, // 이미지 너비, 가로 직사각형 형태로 길게
                child: Image.asset(
                  'assets/images/logo3.png', // 이미지 경로
                  fit: BoxFit.contain, // 이미지 크기 조절
                ),
              ),
            ),
            centerTitle: true, // 타이틀 중앙 정렬
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
                        '0', // 알림 갯수
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
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '마이펫 등록!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 500,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        SizedBox(height: 16),
                        _buildTextField('이름', 'pname', pnameCon),
                        SizedBox(height: 16),
                        _buildTextField('나이', 'page', pageCon),
                        SizedBox(height: 16),
                        _buildTextField('품종', 'pkind', pkindCon),
                        SizedBox(height: 16),
                        _buildTextField('몸무게', 'pkg', pkgCon),
                        Divider(height: 32, thickness: 1),
                        _buildGenderButton(),
                        SizedBox(height: 20),
                        _buildYesNoButton('중성화 여부', 'psurgery', (isNeutered) {
                          setState(() {
                            _selectedNeutered = isNeutered ? '예' : '아니오';
                            _petData['psurgery'] = _selectedNeutered!;
                          });
                        }),
                        SizedBox(height: 20),
                        _buildYesNoButton('질환 여부', 'pdisease', (value) {
                          setState(() {
                            _selectedDisease = value ? '예' : '아니오';
                            _hasDisease = value;
                            _petData['pdisease'] = _selectedDisease!;
                          });
                        }),
                        if (_hasDisease)
                          Column(
                            children: [
                              SizedBox(height: 16),
                              _buildTextField('어떤 질환인지 작성해주세요', 'pdiseaseinf', pdiseaseinfCon),
                            ],
                          ),
                        Divider(height: 32, thickness: 1),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            onPressed: _submit,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                '등록하기',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            onPressed: _cancel,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                '취소하기',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String key, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: '$label 입력하세요',
        prefixIcon: _getPrefixIcon(label),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // 높이 조절
      ),
      style: TextStyle(fontSize: 14), // 폰트 사이즈 줄이기
      onSaved: (value) {
        _petData[key] = value ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label을(를) 입력하세요';
        }
        return null;
      },
    );
  }

  Icon? _getPrefixIcon(String label) {
    switch (label) {
      case '이름':
        return Icon(Icons.pets);
      case '나이':
        return Icon(Icons.cake);
      case '품종':
        return Icon(Icons.category);
      case '몸무게':
        return Icon(Icons.line_weight);
      default:
        return null;
    }
  }

  Widget _buildGenderButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('성별', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSelectionBox('수컷', 'pgender', _selectedGender == '수컷', onChanged: () {
                setState(() {
                  _selectedGender = '수컷';
                  _petData['pgender'] = '수컷';
                });
              }),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildSelectionBox('암컷', 'pgender', _selectedGender == '암컷', onChanged: () {
                setState(() {
                  _selectedGender = '암컷';
                  _petData['pgender'] = '암컷';
                });
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildYesNoButton(String label, String key, Function(bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSelectionBox('예', key, _getSelectedState(key, true), onChanged: () {
                onChanged(true);
              }),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildSelectionBox('아니오', key, _getSelectedState(key, false), onChanged: () {
                onChanged(false);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionBox(String label, String key, bool isSelected, {Function()? onChanged}) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isSelected ? selectedColor : Colors.grey),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  bool _getSelectedState(String key, bool isYes) {
    switch (key) {
      case 'psurgery':
        return _selectedNeutered == (isYes ? '예' : '아니오');
      case 'pdisease':
        return _selectedDisease == (isYes ? '예' : '아니오');
      default:
        return false;
    }
  }
}
