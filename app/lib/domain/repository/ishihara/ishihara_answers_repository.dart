import 'package:boilerplate/domain/entity/ishihara/answer_list.dart';

abstract class IshiharaAnswersRepository {
  // Answers: ------------------------------------------------------------------
  Future<void> changeAnswers(AnswerList anwsers);

  AnswerList? get answers;

  // Result: -------------------------------------------------------------------
  Future<void> setResult(String result);
  Future<void> setResultPercentage(double result);

  String? get result;
  double? get percentage;
}