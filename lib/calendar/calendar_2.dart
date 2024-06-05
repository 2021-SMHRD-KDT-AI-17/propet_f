import 'package:flutter/material.dart';
import 'package:propetsor/calendar/main_calendar.dart';
import 'package:propetsor/calendar/scheduleBottomSheet.dart';
import 'package:propetsor/calendar/scheduleCard.dart';
import 'package:propetsor/calendar/todayBanner.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarUser extends StatefulWidget {
  const CalendarUser({super.key});

  @override
  State<CalendarUser> createState() => _CalendarNonState();
}

class _CalendarNonState extends State<CalendarUser> {
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
          color: Colors.white, // 배경색을 흰색으로 설정
          child: Column(
            children: [
              MainCalendar(
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
              ),
              TodayBanner(
                selectedDate: selectedDate,
                count: 0,
              ),
              SizedBox(
                height: 6,
              ),
              Expanded(
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        ScheduleCard(
                          startTime: 12,
                          endTime: 15,
                          content: "하루 산책 시간",
                        ),
                        // Add more ScheduleCard widgets here if needed
                      ],
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 60, // 원하는 너비로 설정
                        margin: EdgeInsets.only(right: 5.0, top: 3.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => ScheduleBottomSheet(),
                              isScrollControlled: true,
                            );
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.black, // 아이콘 색상을 검은색으로 설정
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
