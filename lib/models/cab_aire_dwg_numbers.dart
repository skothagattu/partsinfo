class CabAireDWGNumber {
  final int no;
  final String prefix;
  final String desc;
  final String model;
  final String orig;
  final String date;
  final int position;
  final int total;

  CabAireDWGNumber({
    required this.no,
    required this.prefix,
    required this.desc,
    required this.model,
    required this.orig,
    required this.date,
    required this.position,
    required this.total,
  });

  CabAireDWGNumber copy() {
    return CabAireDWGNumber(
      no: no,
      prefix: prefix,
      desc: desc,
      model: model,
      orig: orig,
      date: date,
      position: position,
      total: total,
    );
  }

  factory CabAireDWGNumber.fromJson(Map<String, dynamic> json) {
    return CabAireDWGNumber(
      no: json['no'],
      prefix: json['prefix'],
      desc: json['desc'],
      model: json['model'],
      orig: json['orig'],
      date: json['date'],
      position: json['position'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'prefix': prefix,
      'desc': desc,
      'model': model,
      'orig': orig,
      'date': date,
      'position': position,
      'total': total,
    };
  }
}
