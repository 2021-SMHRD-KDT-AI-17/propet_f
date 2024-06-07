class Schedules{

  int? sidx;
  String startTime;
  String endTime;
  String content;
  int uidx;

  Schedules({
    this.sidx,
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.uidx,
  });

  // JSON을 Users 객체로 변환하는 factory 생성자
  factory Schedules.fromJson(Map<String, dynamic> json) {
    return Schedules(
      sidx: json['sidx'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      content: json['content'],
      uidx: json['uidx'],
    );
  }

  // Object -> json으로 바꾸는 형태
  Map<String, dynamic> toJson() => {
    'sidx': sidx,
    'startTime': startTime,
    'endTime': endTime,
    'content': content,
    'uidx': uidx,
  };


}