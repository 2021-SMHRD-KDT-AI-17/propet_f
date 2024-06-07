import 'package:flutter/material.dart';
import 'package:propetsor/calendar/main_calendar.dart';
import 'package:propetsor/calendar/scheduleBottomSheet.dart';
import 'package:propetsor/calendar/scheduleCard.dart';
import 'package:propetsor/calendar/schedule_service.dart';
import 'package:propetsor/calendar/todayBanner.dart';
import 'package:propetsor/model/Schedules.dart';

class CalendarUser extends StatefulWidget {
  const CalendarUser({super.key});

  @override
  State<CalendarUser> createState() => _CalendarUserState();
}

class _CalendarUserState extends State<CalendarUser> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  final ScheduleService _scheduleService = ScheduleService();
  List<Schedules> schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final data = await _scheduleService.getAllSchedules();
    setState(() {
      schedules = data;
    });
  }

  void _createSchedule(Map<String, dynamic> scheduleData) async {
    Schedules schedule = Schedules(
      startTime: scheduleData['startTime'],
      endTime: scheduleData['endTime'],
      content: scheduleData['content'],
      uidx: 0, // This will be set in createSchedule method of ScheduleService
    );
    await _scheduleService.createSchedule(schedule);
    _loadSchedules();
  }

  void _deleteSchedule(int sidx) async {
    await _scheduleService.deleteSchedule(sidx);
    _loadSchedules();
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

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
              TodayBanner(
                selectedDate: selectedDate,
                count: schedules.length,
              ),
              SizedBox(height: 6),
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];
                        return ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          content: schedule.content,
                          onDelete: () => _deleteSchedule(schedule.sidx!),
                        );
                      },
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 60,
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
                              builder: (context) => ScheduleBottomSheet(onSave: _createSchedule),
                              isScrollControlled: true,
                            );
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
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
}
