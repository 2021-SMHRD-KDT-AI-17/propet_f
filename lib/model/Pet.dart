class Pet{
  int? pidx; // 펫 index
  String pname; //펫이름
  String pkind; //종
  int page; // 나이
  double pkg; //몸무게
  String pgender; // 성별
  String psurgery; //중성화 여부
  String pdisease; //질환 여부
  String? pdiseaseinf; //질환정보
  int? uidx; //회원 idx

  Pet({
    required this.pidx,
    required this.pname,
    required this.pkind,
    required this.page,
    required this.pkg,
    required this.pgender,
    required this.psurgery,
    required this.pdisease,
    required this.pdiseaseinf,
    required this.uidx,

  });

  //Map -> Object(인스턴스 생성)
  // factory : 재활용 가능한 생성자(새로운 인스턴스 생성x)
  factory Pet.fromJson(Map<String,dynamic> json)=>Pet(

    pidx: json['pidx'],
    pname: json['pname'],
    pkind: json['pkind'],
    page: json['page'],
    pkg: json['pkg'],
    pgender: json['pgender'],
    psurgery: json['psurgery'],
    pdisease: json['pdisease'],
    pdiseaseinf: json['pdiseaseinf'],
    uidx: json['uidx'],

  );

//Object -> json으로 바꾸는 형태
  Map<String, dynamic> toJson()=>{

    'pidx':pidx,
    'pname':pname,
    'pkind':pkind,
    'page':page,
    'pkg':pkg,
    'pgender':pgender,
    'psurgery':psurgery,
    'pdisease':pdisease,
    'pdiseaseinf':pdiseaseinf,
    'uidx':uidx,
  };


  Pet.enroll({

    required this.pname,
    required this.pkind,
    required this.page,
    required this.pkg,
    required this.pgender,
    required this.psurgery,
    required this.pdisease,
    this.pdiseaseinf,
    this.uidx,
  });
  // Object -> Map<String, String> 변환 메서드
  Map<String, String> toMap() {
    return {
      'pidx': pidx.toString(),
      'pname': pname,
      'pkind': pkind,
      'page': page.toString(),
      'pkg': pkg.toString(),
      'pgender': pgender,
      'psurgery': psurgery,
      'pdisease': pdisease,
      'pdiseaseinf': pdiseaseinf ?? '',
      'uidx': uidx.toString(),
    };
  }
}