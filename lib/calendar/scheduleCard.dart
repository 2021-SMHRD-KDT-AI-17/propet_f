import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // 왼쪽 정렬
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5.0, top: 3.0, bottom: 5.0), // 마진 설정
            width: MediaQuery.of(context).size.width * 0.8, // 박스의 너비를 줄입니다.
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1.0,
                color: Colors.black, // 테두리 색상을 검은색으로 변경
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Time(
                      startTime: startTime,
                      endTime: endTime,
                    ),
                    VerticalDivider(
                      color: Colors.black, // 세로줄 색상을 검은색으로 설정
                      thickness: 1.0,
                      width: 16.0, // 세로줄의 여유 공간
                    ),
                    _Content(
                      content: content,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5), // 박스 끝에 10px 간격을 추가
        ],
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: 'Omyu',
      color: Colors.black,
      fontSize: 18.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${startTime.toString().padLeft(2, '0')}:00 ~ ${endTime.toString().padLeft(2, '0')}:00',
          style: textStyle,
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          content,
          style: TextStyle(
            fontFamily: 'Omyu',
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
