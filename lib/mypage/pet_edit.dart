import 'package:flutter/material.dart';
import 'package:propetsor/mainPage/main_2.dart';

class PetEdit extends StatefulWidget {
  final Map<String, String> petData;
  final Function(Map<String, String>) onEdit;

  const PetEdit({Key? key, required this.petData, required this.onEdit}) : super(key: key);

  @override
  _PetEditState createState() => _PetEditState();
}

class _PetEditState extends State<PetEdit> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, String> _petData;

  bool _hasDisease = false;
  String? _selectedGender;
  String? _selectedNeutered;
  String? _selectedDisease;

  final Color selectedColor = Colors.deepPurpleAccent;
  final Color unselectedColor = Colors.grey[300]!;

  @override
  void initState() {
    super.initState();
    _petData = Map<String, String>.from(widget.petData);
    _selectedGender = _petData['pgender'];
    _selectedNeutered = _petData['psurgery'];
    _selectedDisease = _petData['pdisease'];
    _hasDisease = _selectedDisease == '예';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onEdit(_petData);
      Navigator.pop(context);
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // 뒤로가기 동작
              },
            ),
            backgroundColor: Colors.white,
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
                    '마이펫 수정!',
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
                        _buildTextField('이름', 'pname'),
                        SizedBox(height: 16),
                        _buildTextField('나이', 'page'),
                        SizedBox(height: 16),
                        _buildTextField('품종', 'pkind'),
                        SizedBox(height: 16),
                        _buildTextField('몸무게', 'pkg'),
                        Divider(height: 32, thickness: 1), // 성별 위에 라인 추가
                        _buildGenderButton(),
                        SizedBox(height: 20), // 버튼과 중성화 여부 간격 추가
                        _buildYesNoButton('중성화 여부', 'psurgery', (isNeutered) {
                          setState(() {
                            _selectedNeutered = isNeutered ? '예' : '아니오';
                            _petData['psurgery'] = _selectedNeutered!;
                          });
                        }),
                        SizedBox(height: 20), // 버튼과 질환 여부 간격 추가
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
                              SizedBox(height: 16), // 간격 추가
                              _buildTextField('어떤 질환인지 작성해주세요', 'pdiseaseinf'),
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
                                '수정하기',
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

  Widget _buildTextField(String label, String key) {
    return TextFormField(
      initialValue: _petData[key],
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
        return Icon(Icons.drive_file_rename_outline);
      case '나이':
        return Icon(Icons.cake);
      case '품종':
        return Icon(Icons.pets);
      case '몸무게':
        return Icon(Icons.monitor_weight);
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
              child: _buildSelectionBox('수컷', 'gender', _selectedGender == '수컷', onChanged: () {
                setState(() {
                  _selectedGender = '수컷';
                  _petData['pgender'] = '수컷';
                });
              }),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildSelectionBox('암컷', 'gender', _selectedGender == '암컷', onChanged: () {
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
                setState(() {
                  onChanged(true);
                });
              }),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildSelectionBox('아니오', key, _getSelectedState(key, false), onChanged: () {
                setState(() {
                  onChanged(false);
                });
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
