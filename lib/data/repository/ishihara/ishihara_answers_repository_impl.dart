import 'dart:convert';

import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/domain/entity/ishihara/answer_list.dart';
import 'package:boilerplate/domain/repository/ishihara/ishihara_answers_repository.dart';

class IshiharaAnswersRepositoryImpl extends IshiharaAnswersRepository {
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  IshiharaAnswersRepositoryImpl(this._sharedPrefsHelper);

  // Answers: ------------------------------------------------------------------
  @override
  AnswerList? get answers => _sharedPrefsHelper.ishiharaAnswers != null
    ? AnswerList.fromJson(json.decode(_sharedPrefsHelper.ishiharaAnswers!))
    : null ;

  @override
  Future<void> changeAnswers(AnswerList answers) =>
    _sharedPrefsHelper.changeIshiharaAnswers(answers.toJson());

}