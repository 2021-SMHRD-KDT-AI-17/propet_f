import 'package:flutter/material.dart';
import 'package:propetsor/calendar/main_calendar.dart';
import 'package:propetsor/calendar/todayBanner.dart';
import 'package:propetsor/login/login.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarNon extends StatefulWidget {
  const CalendarNon({super.key});

  @override
  State<CalendarNon> createState() => _CalendarNonState();
}

class _CalendarNonState extends State<CalendarNon> {

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              MainCalendar(
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
              ),
              SizedBox(height: 30),
              TodayBanner(
                  selectedDate: selectedDate,
                  count: 0
              ),
          SizedBox(height: 30),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(), // 초기 인덱스를 1로 설정
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 60), // 좌우 마진 추가
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.login,
                    color: Colors.white, // 아이콘 색상
                    size: 24, // 아이콘 크기
                  ),
                  SizedBox(width: 10), // 아이콘과 텍스트 사이 간격 조정
                  Text(
                    '로그인 후 이용해 주세요.',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Geekble',
                      color: Colors.white, // 텍스트 색상
                    ),
                  ),
                ],
              ),
            ),
          )
            ],

          ),
        ),
      ),
    );
  }
  void onDaySelected(DateTime selectedDate, DateTime focusedDate){
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
