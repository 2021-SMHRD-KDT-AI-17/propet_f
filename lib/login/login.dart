import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:propetsor/login/join.dart';

import 'package:propetsor/model/Users.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isSmallScreen
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _Logo(),
            _FormContent(),
          ],
        )
            : Container(
          padding: const EdgeInsets.all(32.0),
          constraints: const BoxConstraints(maxWidth: 800),
          child: Row(
            children: const [
              Expanded(child: _Logo()),
              Expanded(
                child: Center(child: _FormContent()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo1.png',
          width: isSmallScreen ? 200 : 400,
          height: isSmallScreen ? 200 : 400,
        ),
      ],
    );
  }
}

Widget _buildSocialLoginButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: _buildSocialLoginButton(
          text: 'N', // 네이버 아이콘 텍스트
          color: const Color(0xFF03C75A), // 네이버 메인 색상
          onTap: () {
            // 네이버 로그인 로직
          },
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _buildSocialLoginButton(
          text: 'K', // 카카오 아이콘 텍스트
          color: const Color(0xFFFFE812), // 카카오 메인 색상
          onTap: () {
            // 카카오 로그인 로직
          },
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _buildSocialLoginButton(
          text: 'G', // 구글 아이콘 텍스트
          color: const Color(0xFF4285F4), // 구글 메인 색상
          onTap: () {
            // 구글 로그인 로직
          },
        ),
      ),
    ],
  );
}

Widget _buildSocialLoginButton({
  required String text,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 36,
      decoration: BoxDecoration(
        color: color,

      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white, // 텍스트 색상
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController idCon = TextEditingController();
  TextEditingController pwCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: idCon,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter some text';
              //   }
              //
              //   bool idValid = RegExp(
              //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              //       .hasMatch(value);
              //   if (!idValid) {
              //     return 'Please enter a valid email';
              //   }
              //
              //   return null;
              // },
              decoration: const InputDecoration(
                labelText: 'ID',
                hintText: 'Enter your ID',
                prefixIcon: Icon(Icons.perm_identity),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: pwCon,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 0) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            _buildSocialLoginButtons(), // SNS 로그인 버튼 추가
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '로그인',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // 로그인 로직 처리
                    Users m = Users.login(id: idCon.text, pw: pwCon.text);
                    loginMember(m,context);
                  }

                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent), // 배경색
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // 텍스트 색상
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                onPressed: () {
                  // 추가적인 로직 처리
                  Navigator.push(context, MaterialPageRoute(builder: (context) => JoinPage()));
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '회원가입',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}


void loginMember(member, context) async {
  final dio = Dio();
  final storage = FlutterSecureStorage();

  try {
    Response res = await dio.post(
      'http://59.0.236.149:8089/boot/login',
      data: {'loginMember': member},
    );
    print(res);

    // 응답이 성공적으로 받아졌을 때의 처리
    if (res.toString() != '') {
      // 스토리지에 로그인 한 회원 정보 저장하기 - write
      await storage.write(key: 'member', value: res.data.toString());

      // 로그인 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 성공했습니다.'),
          backgroundColor: Colors.green,
        ),
      );

      // 메인 화면으로 이동 (이전 모든 화면 삭제)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => JoinPage()), // YourMainPage 대신에 이동할 페이지를 지정하세요.
            (route) => false,
      );
    } else {
      // 로그인 실패 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Dio 요청 중 예외 발생 시 오류 메시지 출력
    print('Error: $e');

    // 예외에 따른 오류 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('서버에 연결할 수 없습니다.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

