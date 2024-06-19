class ThreeLetterCode {
  final String code;
  final String type;
  final String company;
  final String addresS1;
  final String addresS2;
  final String citY_STATE_ZIP;
  final String contacT1;
  final String phonE1;
  final String exT1;
  final String contacT2;
  final String phonE2;
  final String exT2;
  final String fax;
  final String terms;
  final String fob;
  final String notes;
  final int position;
  final int total;

  ThreeLetterCode({
    required this.code,
    required this.type,
    required this.company,
    required this.addresS1,
    required this.addresS2,
    required this.citY_STATE_ZIP,
    required this.contacT1,
    required this.phonE1,
    required this.exT1,
    required this.contacT2,
    required this.phonE2,
    required this.exT2,
    required this.fax,
    required this.terms,
    required this.fob,
    required this.notes,
    required this.position,
    required this.total,
  });

  factory ThreeLetterCode.fromJson(Map<String, dynamic> json) {
    return ThreeLetterCode(
      code: json['code'] ?? ' ',
      type: json['type'] ?? ' ',
      company: json['company'] ?? ' ',
      addresS1: json['addresS1'] ?? ' ',
      addresS2: json['addresS2'] ?? ' ',
      citY_STATE_ZIP: json['citY_STATE_ZIP'] ?? ' ',
      contacT1: json['contacT1'] ?? ' ',
      phonE1: json['phonE1'] ?? ' ',
      exT1: json['exT1'] ?? ' ',
      contacT2: json['contacT2'] ?? ' ',
      phonE2: json['phonE2'] ?? ' ',
      exT2: json['exT2'] ?? ' ',
      fax: json['fax'] ?? ' ',
      terms: json['terms'] ?? ' ',
      fob: json['fob'] ?? ' ',
      notes: json['notes'] ?? ' ',
      position: json['position'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'type': type,
      'company': company,
      'addresS1': addresS1,
      'addresS2': addresS2,
      'citY_STATE_ZIP': citY_STATE_ZIP,
      'contacT1': contacT1,
      'phonE1': phonE1,
      'exT1': exT1,
      'contacT2': contacT2,
      'phonE2': phonE2,
      'exT2': exT2,
      'fax': fax,
      'terms': terms,
      'fob': fob,
      'notes': notes,
      'position': position,
      'total': total,
    };
  }
}
