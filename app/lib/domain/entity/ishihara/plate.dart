class Plate {
  int order;
  int? normal;
  int? redGreenDeficiency;
  int? protanopia;
  int? deuteranopia;

  Plate({
    required this.order,
    this.normal,
    this.redGreenDeficiency,
    this.protanopia,
    this.deuteranopia
  });

  factory Plate.fromJson(Map<String, dynamic> json) => Plate(
    order: json['order'],
    normal: json['normal'],
    redGreenDeficiency: json['redGreenDeficiency'],
    protanopia: json['protanopia'],
    deuteranopia: json['deuteranopia']
  );

  Map<String, dynamic> toMap() => {
    "order": order,
    "normal": normal,
    "redGreenDeficiency": redGreenDeficiency,
    "protanopia": protanopia,
    "deuteranopia": deuteranopia,
  };

  @override
  String toString() {
    return toMap().toString();
  }
}

enum PlateType { number, line }
