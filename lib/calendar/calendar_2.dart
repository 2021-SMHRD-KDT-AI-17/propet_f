import 'package:flutter/material.dart';
import 'package:propetsor/calendar/main_calendar.dart';
import 'package:propetsor/calendar/scheduleBottomSheet.dart';
import 'package:propetsor/calendar/scheduleCard.dart';
import 'package:propetsor/calendar/schedule_service.dart';
import 'package:propetsor/calendar/todayBanner.dart';
import 'package:propetsor/model/Schedules.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadSchedulesByDate(selectedDate); // 초기 로드 시 현재 날짜의 일정 로드
  }

  Future<void> _loadSchedulesByDate(DateTime date) async {
    String? uidx = await storage.read(key: 'uidx');
    if (uidx != null) {
      final data = await _scheduleService.getSchedulesByDateAndUser(
          int.parse(uidx), date.toIso8601String().split('T')[0]);
      setState(() {
        schedules = data;
      });
    }
  }

  void _createSchedule(Map<String, dynamic> scheduleData) async {
    Schedules schedule = Schedules(
      startTime: scheduleData['startTime'],
      endTime: scheduleData['endTime'],
      content: scheduleData['content'],
      uidx: 0,
      ndate: DateTime.parse(scheduleData['ndate']).toIso8601String().split('T')[0], // ndate 필드 수정
    );
    await _scheduleService.createSchedule(schedule);
    _loadSchedulesByDate(selectedDate);
  }

  void _deleteSchedule(int sidx) async {
    await _scheduleService.deleteSchedule(sidx);
    _loadSchedulesByDate(selectedDate);
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
    _loadSchedulesByDate(selectedDate);
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
                        height: 120,
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
