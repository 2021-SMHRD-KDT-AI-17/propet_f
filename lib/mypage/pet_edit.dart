import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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

  late TextEditingController pnameCon;
  late TextEditingController pkindCon;
  late TextEditingController pageCon;
  late TextEditingController pkgCon;
  late TextEditingController pdiseaseinfCon;

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

    pnameCon = TextEditingController(text: _petData['pname']);
    pkindCon = TextEditingController(text: _petData['pkind']);
    pageCon = TextEditingController(text: _petData['page']);
    pkgCon = TextEditingController(text: _petData['pkg']);
    pdiseaseinfCon = TextEditingController(text: _petData['pdiseaseinf']);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _petData['pname'] = pnameCon.text;
      _petData['pkind'] = pkindCon.text;
      _petData['page'] = pageCon.text;
      _petData['pkg'] = pkgCon.text;
      _petData['pdiseaseinf'] = pdiseaseinfCon.text;

      try {
        Response res = await Dio().post(
          'http://10.0.2.2:8089/boot/updatePet',
          data: {'updatePet': _petData},
        );

        if (res.statusCode == 200) {
          widget.onEdit(_petData);
          Navigator.pop(context);
        } else {
          throw Exception('Failed to update pet');
        }
      } catch (e) {
        print('Error occurred: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to update pet. Please try again later.'),
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
  void dispose() {
    pnameCon.dispose();
    pkindCon.dispose();
    pageCon.dispose();
    pkgCon.dispose();
    pdiseaseinfCon.dispose();
    super.dispose();
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage_2()),
                );
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
                    onPressed: () {},
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
                        _buildTextField('이름', pnameCon),
                        SizedBox(height: 16),
                        _buildTextField('나이', pageCon),
                        SizedBox(height: 16),
                        _buildTextField('품종', pkindCon),
                        SizedBox(height: 16),
                        _buildTextField('몸무게', pkgCon),
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
                              _buildTextField('어떤 질환인지 작성해주세요', pdiseaseinfCon),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: '$label 입력하세요',
        prefixIcon: _getPrefixIcon(label),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      style: TextStyle(fontSize: 14),
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
