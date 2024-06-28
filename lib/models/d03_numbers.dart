class D03numbers {
  final int id;
  final String description;
  final String bL_NUMBER;
  final String paneL_DWG;
  final String who;
  final String starT_DATE;
  final String model;
  final int position;
  final int total;

  D03numbers({
    required this.id,
    required this.description,
    required this.bL_NUMBER,
    required this.paneL_DWG,
    required this.who,
    required this.starT_DATE,
    required this.model,
    required this.position,
    required this.total,
  });

  D03numbers copy() {
    return D03numbers(
      id: id,
      description: description,
      bL_NUMBER: bL_NUMBER,
      paneL_DWG: paneL_DWG,
      who: who,
      starT_DATE: starT_DATE,
      model: model,
      position: position,
      total: total,
    );
  }

  factory D03numbers.fromJson(Map<String, dynamic> json) {
    return D03numbers(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      bL_NUMBER: json['bL_NUMBER'] ?? '',
      paneL_DWG: json['paneL_DWG'] ?? '',
      who: json['who'] ?? '',
      starT_DATE: json['starT_DATE'] ?? '',
      model: json['model'] ?? '',
      position: json['position'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'bL_NUMBER': bL_NUMBER,
      'paneL_DWG': paneL_DWG,
      'who': who,
      'starT_DATE': starT_DATE,
      'model': model,
      'position': position,
      'total': total,
    };
  }
}
