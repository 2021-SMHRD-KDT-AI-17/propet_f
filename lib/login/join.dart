import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:propetsor/login/login.dart';
import 'package:propetsor/model/Users.dart';
import 'package:cherry_toast/cherry_toast.dart';

class JoinPage extends StatelessWidget {
  const JoinPage({Key? key}) : super(key: key);

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

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController idCon=TextEditingController();
  TextEditingController pwCon=TextEditingController();
  TextEditingController nameCon=TextEditingController();
  TextEditingController phoneCon=TextEditingController();

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
              decoration: const InputDecoration(
                labelText: 'Id',
                hintText: 'Enter your ID',
                prefixIcon: Icon(Icons.perm_identity),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: pwCon,
              decoration: const InputDecoration(
                labelText: 'Pw',
                hintText: 'Enter your PW',
                prefixIcon: Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: nameCon,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your Name',
                prefixIcon: Icon(Icons.drive_file_rename_outline),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: phoneCon,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter your Phone',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
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
                  Users m = Users.join(id: idCon.text, uname: nameCon.text, uphone: phoneCon.text, pw: pwCon.text);
                  joinMember(m,context);
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '회원가입 완료',
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

void joinMember(member,context) async{

  //boot 서버로 member 객체 보내기!(비동기 통신->dio라이브러리)
  final dio = Dio();

  // 비동기 통신 -> 회원가입 (boot로 요청)
  // 응답 올때까지 기다려야함(await)
  Response res =await dio.post(
    'http://59.0.236.149:8089/boot/join', // 요청. url(경로)
    data: {'joinMember':member}, // 요쳥할 때 같이 보낼 데이터(json-key:value)
  );

  if(int.parse(res.toString())==1){ // 회원가입 성공
    CherryToast.success(
      title: Text('회원가입에 성공했습니다'),
    ).show(context);
    // main -> login_view -> join_view
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()), // YourMainPage 대신에 이동할 페이지를 지정하세요.
          (route) => false,
    );
  }else{ //0 회원가입 실패
    CherryToast.info(
      title: Text('회원가입에 실패했습니다'),
    ).show(context);
  }

}