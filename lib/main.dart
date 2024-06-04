import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:propetsor/login/join.dart';
import 'package:propetsor/login/login.dart';
import 'package:propetsor/mainPage/main_1.dart';
import 'package:propetsor/mainPage/main_2.dart';
import 'package:propetsor/mainPage/start.dart';
import 'package:propetsor/model/Users.dart';

final storage = FlutterSecureStorage();

void main() async {
  runApp(MyApp());
}

Future<void> clearSecureStorage() async {
  final storage = FlutterSecureStorage();
  await storage.deleteAll();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _checkLoginStatus() async {
    return await storage.read(key: 'member');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {

        if(snapshot.data!=null){ //로그인후
          Map<String,dynamic> jsonMember = jsonDecode(snapshot.data!);

          Users member = Users.fromJson(jsonMember);
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(

                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const MainPage_2()
          );
        }else{//로그인전
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(

                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: StartScreen()
          );
        }

      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

//   로그인 상태 확인
  Future<String?> _checkLoginStatus() async{
//     storage 'member' 값이 저장 되어 있는지/안 되어 있는지
//   storage.read 값 가져오기
//   로그인 하지 않은 상태 => null 이라 ? 붙이기
    String? value = await storage.read(key: 'member');
    return value;
  }

  //로그아웃
  void logout(context) async{
    //스토리지에 저장된 정보('member') 삭제
    await storage.delete(key: 'member');
    await storage.delete(key: 'uidx');
    await storage.delete(key: 'uname');

    CherryToast.success(
      title: Text('로그아웃 성공했습니다'),
    ).show(context);

    //현재 페이지 pop 다시 push
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage_1()));

  }




}
