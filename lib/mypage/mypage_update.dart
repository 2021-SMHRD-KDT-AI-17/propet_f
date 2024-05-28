import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propetsor/mainPage/main_2.dart';
import 'package:propetsor/mainPage/main_user.dart';
import 'dart:io';

class ProfileUpdate extends StatelessWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

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

class _Logo extends StatefulWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  State<_Logo> createState() => __LogoState();
}

class __LogoState extends State<_Logo> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: isSmallScreen ? 80 : 80,
          backgroundImage: _image != null ? FileImage(_image!) : AssetImage('assets/images/logo1.png') as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkResponse(
            onTap: _pickImage,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey,
                size: isSmallScreen ? 24 : 24,
              ),
            ),
            radius: 10,
            borderRadius: BorderRadius.circular(30),
            splashColor: Colors.grey.withOpacity(0.5),
            highlightShape: BoxShape.circle,
          ),
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
            _gap(),
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
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage_2()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '업데이트!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '취소',
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
