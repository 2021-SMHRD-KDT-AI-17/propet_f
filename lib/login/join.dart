import 'package:flutter/material.dart';

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
              decoration: const InputDecoration(
                labelText: 'Id',
                hintText: 'Enter your ID',
                prefixIcon: Icon(Icons.perm_identity),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Pw',
                hintText: 'Enter your PW',
                prefixIcon: Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your Name',
                prefixIcon: Icon(Icons.drive_file_rename_outline),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
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
