import 'package:boilerplate/domain/entity/ishihara/plate.dart';

class Answer {
  Plate plate;
  bool cantSee;
  int? answer;

  Answer({
    required this.plate,
    required this.cantSee,
    required this.answer
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    plate: Plate.fromJson(json['plate']),
    cantSee: json['cantSee'],
    answer: json['answer'],
  );

  Map<String, dynamic> toMap() => {
    "plate": plate.toMap(),
    "cantSee": cantSee,
    "answer": answer
  };

  @override
  String toString() {
    return toMap().toString();
  }
}