import 'package:flutter/material.dart';
import 'package:propetsor/calendar/customTextField.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const ScheduleBottomSheet({Key? key, required this.onSave}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 2 + bottomInset,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: bottomInset + 16,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: '시작 시간',
                      isTime: true,
                      controller: _startTimeController,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: CustomTextField(
                      label: '종료 시간',
                      isTime: true,
                      controller: _endTimeController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: CustomTextField(
                  label: '내용',
                  isTime: false,
                  controller: _contentController,
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSavePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    '저장하기',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Geekble',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSavePressed() {
    final schedule = {
      'startTime': _startTimeController.text,
      'endTime': _endTimeController.text,
      'content': _contentController.text,
    };
    widget.onSave(schedule);
    Navigator.pop(context);
  }
}
