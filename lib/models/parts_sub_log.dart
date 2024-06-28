class PartSubLog {
  final String no;
  final String parT_NO;
  final String desc;
  final String reQ_BY;
  final String reQ_DATE;
  final String assign;
  final String accept;
  final String reject;
  final String date;
  final int position;
  final int total;

  PartSubLog({
    required this.no,
    required this.parT_NO,
    required this.desc,
    required this.reQ_BY,
    required this.reQ_DATE,
    required this.assign,
    required this.accept,
    required this.reject,
    required this.date,
    required this.position,
    required this.total,
  });

  PartSubLog copy() {
    return PartSubLog(
      no: no,
      parT_NO: parT_NO,
      desc: desc,
      reQ_BY: reQ_BY,
      reQ_DATE: reQ_DATE,
      assign: assign,
      accept: accept,
      reject: reject,
      date: date,
      position: position,
      total: total,
    );
  }

  factory PartSubLog.fromJson(Map<String, dynamic> json) {
    return PartSubLog(
      no: json['no'] ?? ' ',
      parT_NO: json['parT_NO'] ?? ' ',
      desc: json['desc'] ?? ' ',
      reQ_BY: json['reQ_BY'] ?? ' ',
      reQ_DATE: json['reQ_DATE'] ?? ' ',
      assign: json['assign'] ?? ' ',
      accept: json['accept'] ?? ' ',
      reject: json['reject'] ?? ' ',
      date: json['date'] ?? ' ',
      position: json['position'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'parT_NO': parT_NO,
      'desc': desc,
      'reQ_BY': reQ_BY,
      'reQ_DATE': reQ_DATE,
      'assign': assign,
      'accept': accept,
      'reject': reject,
      'date': date,
      'position': position,
      'total': total,
    };
  }
}
