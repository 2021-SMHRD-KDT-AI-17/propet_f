import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isTime;
  const CustomTextField({
    required this.label,
    required this.isTime,
    Key? key,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          flex: widget.isTime ? 0 : 1,
          child: widget.isTime
              ? GestureDetector(
            onTap: _selectTime,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 2.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : '시간 선택',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Icon(
                    Icons.access_time,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
          )
              : TextFormField(
            cursorColor: Colors.yellowAccent,
            maxLines: widget.isTime ? 1 : null,
            expands: !widget.isTime,
            keyboardType: widget.isTime ? TextInputType.number : TextInputType.multiline,
            inputFormatters: widget.isTime
                ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
                : [],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.deepPurple, // 보더 색상 설정
                  width: 2.0, // 보더 두께 설정
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.deepPurple, // 비활성화 상태의 보더 색상 설정
                  width: 2.0, // 보더 두께 설정
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(
                  color: Colors.deepPurple, // 포커스 상태의 보더 색상 설정
                  width: 2.0, // 보더 두께 설정
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixText: widget.isTime ? '시' : null,
            ),
          ),
        ),
      ],
    );
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}