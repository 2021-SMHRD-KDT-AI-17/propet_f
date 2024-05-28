class Users{

  int? uidx;
  String? id;
  String? uname;
  String? pw;
  String? uphone;

  Users({
    required this.uidx,
    required this.id,
    required this.uname,
    required this.pw,
    required this.uphone,

  });


  //Map -> Object(인스턴스 생성)
  // factory : 재활용 가능한 생성자(새로운 인스턴스 생성x)
  factory Users.fromJson(Map<String,dynamic> json)=>Users(
      uidx: json['uidx'],
      id: json['id'],
    uname: json['uname'],
    uphone: json['uphone'],
    pw: json['pw'],

  );

//Object -> json으로 바꾸는 형태
  Map<String, dynamic> toJson()=>{
    'uidx':uidx,
    'id':id,
    'uname':uname,
    'uphone':uphone,
    'pw':pw,
  };


  Users.join({

    required this.id,
    required this.uname,
    required this.uphone,
    required this.pw,
  });


  Users.login({
    //id,password 외에는 null값 허용되게 해야함!!
    required this.id,
    required this.pw,


  });


  Users.update({
    required this.uidx,
    required this.pw,
    required this.uphone,
    required this.uname,
  });



}