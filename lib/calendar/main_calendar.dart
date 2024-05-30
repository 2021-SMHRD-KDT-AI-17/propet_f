import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected; // 날짜가 선택되었을 때 호출되는 콜백 함수
  final DateTime selectedDate; // 선택된 날짜를 저장하는 변수

  MainCalendar({
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TableCalendar(
        onDaySelected: onDaySelected, // 날짜 선택 시 호출되는 함수
        selectedDayPredicate: (date) => // 선택된 날짜인지 확인하는 함수
        date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day,
        focusedDay: DateTime.now(), // 달력에서 기본적으로 포커스되는 날짜
        firstDay: DateTime(2023, 1, 1), // 달력에서 선택할 수 있는 첫 번째 날짜
        lastDay: DateTime(2026, 1, 1), // 달력에서 선택할 수 있는 마지막 날짜
        headerStyle: HeaderStyle( // 달력 헤더 스타일 설정
          titleCentered: true, // 제목을 가운데 정렬
          formatButtonVisible: false, // 포맷 버튼을 숨김
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        calendarStyle: CalendarStyle( // 달력 스타일 설정
          isTodayHighlighted: false, // 오늘 날짜를 강조하지 않음
          defaultDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white, // 기본 날짜의 배경색
          ),
          weekendDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white, // 주말 날짜의 배경색
          ),
          selectedDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white, // 선택된 날짜의 배경색을 흰색으로 설정
            border: Border.all(
              color: Colors.deepPurple, // 선택된 날짜의 테두리 색상
              width: 1.0,
            ),
          ),
          defaultTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple, // 기본 날짜의 텍스트 색상
          ),
          weekendTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.red[300], // 주말 날짜의 텍스트 색상
          ),
          selectedTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple, // 선택된 날짜의 텍스트 색상
          ),
        ),
      ),
    );
  }
}
