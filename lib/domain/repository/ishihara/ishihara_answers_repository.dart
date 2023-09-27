import 'package:boilerplate/domain/entity/ishihara/answer_list.dart';

abstract class IshiharaAnswersRepository {
  // Answers: ------------------------------------------------------------------
  Future<void> changeAnswers(AnswerList anwsers);

  AnswerList? get answers;

  // Result: -------------------------------------------------------------------
}