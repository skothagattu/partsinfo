class EcrLog {
  int no;
  String desc;
  String model;
  String dateLog;
  String name;
  String eco;
  String dateRel;
  int position;
  int total;

  EcrLog({
    required this.no,
    required this.desc,
    required this.model,
    required this.dateLog,
    required this.name,
    required this.eco,
    required this.dateRel,
    required this.position,
    required this.total,
  });

  factory EcrLog.fromJson(Map<String, dynamic> json) {
    return EcrLog(
      no: json['no'],
      desc: json['desc'],
      model: json['model'],
      dateLog: json['datE_LOG'],
      name: json['name'],
      eco: json['eco'],
      dateRel: json['datE_REL'],
      position: json['position'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'desc': desc,
      'model': model,
      'datE_LOG': dateLog,
      'name': name,
      'eco': eco,
      'datE_REL': dateRel,
      'position': position,
      'total': total,
    };
  }

  EcrLog copy() {
    return EcrLog(
      no: no,
      desc: desc,
      model: model,
      dateLog: dateLog,
      name: name,
      eco: eco,
      dateRel: dateRel,
      position: position,
      total: total,
    );
  }
}
