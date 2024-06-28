class DWGNumbers {
  final String prefix;
  final int no;
  final String desc;
  final String model;
  final String orig;
  final String date;
  final int position;
  final int total;

  DWGNumbers({
    required this.prefix,
    required this.no,
    required this.desc,
    required this.model,
    required this.orig,
    required this.date,
    required this.position,
    required this.total,
  });

  DWGNumbers copy() {
    return DWGNumbers(
      prefix: prefix,
      no: no,
      desc: desc,
      model: model,
      orig: orig,
      date: date,
      position: position,
      total: total,
    );
  }

  factory DWGNumbers.fromJson(Map<String, dynamic> json) {
    return DWGNumbers(
      prefix: json['prefix'] ?? '',
      no: json['no'] ?? 0,
      desc: json['desc'] ?? '',
      model: json['model'] ?? '',
      orig: json['orig'] ?? '',
      date: json['date'] ?? '',
      position: json['position'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
      'no': no,
      'desc': desc,
      'model': model,
      'orig': orig,
      'date': date,
      'position': position,
      'total': total,
    };
  }
}
