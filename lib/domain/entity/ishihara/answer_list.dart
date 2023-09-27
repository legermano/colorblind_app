import 'dart:convert';

import 'package:boilerplate/domain/entity/ishihara/answer.dart';

class AnswerList {
  List<Answer>? answers;

  AnswerList({
    this.answers
  });

  factory AnswerList.fromJson(List<dynamic> json) {
    List<Answer> answers = <Answer>[];
    answers = json.map((answer) => Answer.fromJson(answer)).toList();

    return AnswerList(
      answers: answers
    );
  }

  String toJson() => json.encode(
    this.answers
      ?.map<Map<String, dynamic>>((answer) => answer.toMap())
      .toList()
  );
}