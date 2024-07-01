class EcoLog {
  int no;
  String desc;
  String model;
  String ecr;
  String datE_LOG;
  String name;
  String datE_REL;
  int position;
  int total;

  EcoLog({
    required this.no,
    required this.desc,
    required this.model,
    required this.ecr,
    required this.datE_LOG,
    required this.name,
    required this.datE_REL,
    required this.position,
    required this.total,
  });

  factory EcoLog.fromJson(Map<String, dynamic> json) {
    return EcoLog(
      no: json['no'],
      desc: json['desc'],
      model: json['model'],
      ecr: json['ecr'],
      datE_LOG: json['datE_LOG'],
      name: json['name'],
      datE_REL: json['datE_REL'],
      position: json['position'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'desc': desc,
      'model': model,
      'ecr': ecr,
      'datE_LOG': datE_LOG,
      'name': name,
      'datE_REL': datE_REL,
      'position': position,
      'total': total,
    };
  }

  EcoLog copy() {
    return EcoLog(
      no: no,
      desc: desc,
      model: model,
      ecr: ecr,
      datE_LOG: datE_LOG,
      name: name,
      datE_REL: datE_REL,
      position: position,
      total: total,
    );
  }
}
