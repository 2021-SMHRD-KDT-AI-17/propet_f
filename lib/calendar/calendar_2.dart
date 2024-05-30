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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: (){
          showModalBottomSheet(
              context: context,
              builder: (context) => ScheduleBottomSheet(),
          isScrollControlled: true
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              MainCalendar(
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
              ),
              SizedBox(
                height: 20,
              ),
              TodayBanner(
                  selectedDate: selectedDate,
                  count: 0
              ),
              SizedBox(
                height: 6,
              ),
              ScheduleCard(
                  startTime: 12,
                  endTime: 15,
                  content: "하루 산책 시간")
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
