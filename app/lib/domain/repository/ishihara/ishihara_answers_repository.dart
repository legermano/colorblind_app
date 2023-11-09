import 'package:boilerplate/domain/entity/ishihara/answer_list.dart';

abstract class IshiharaAnswersRepository {
  // Answers: ------------------------------------------------------------------
  Future<void> setAnswers(String uid, AnswerList anwsers);

  Future<AnswerList?> getAnswers(String uid);

  // Result: -------------------------------------------------------------------
  Future<void> setResult(String uid, String result);
  Future<void> setResultPercentage(String uid, double result);

  Future<String?> getResult(String uid);
  Future<double?> getPercentage(String uid);
}