import 'package:flutter/material.dart';
import 'package:propetsor/calendar/main_calendar.dart';
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
