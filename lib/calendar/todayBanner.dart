import 'package:flutter/material.dart';
class TodayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;
  const TodayBanner({
      required this.selectedDate,
      required this.count,
      Key? key,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDate.year}.${selectedDate.month}.${selectedDate.day}',
              style: textStyle,
            ),
            Text(
              '$count개',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
