import 'package:boilerplate/domain/entity/ishihara/answer.dart';
import 'package:boilerplate/domain/entity/ishihara/answer_list.dart';
import 'package:boilerplate/domain/repository/ishihara/ishihara_answers_repository.dart';
import 'package:mobx/mobx.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final IshiharaAnswersRepository _answersRepository;

  // constructor:---------------------------------------------------------------
  _UserStore(this._answersRepository) {
    init();
  }

  // store variables:-----------------------------------------------------------
  @observable
  AnswerList _answers = AnswerList();

  @computed
  List<Answer> get answers => _answers.answers ?? [];

  // actions:-------------------------------------------------------------------
  @action
  void changeAnswers(List<Answer> answers) {
    _answers.answers = answers;
    _answersRepository.changeAnswers(_answers);
  }

  // general:-------------------------------------------------------------------
  void init() async {
    // getting current language from shared preference
    if (_answersRepository.answers != null) {
      _answers = _answersRepository.answers!;
    }
  }
}