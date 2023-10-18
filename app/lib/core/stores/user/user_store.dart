import 'package:boilerplate/constants/colorblind_type.dart';
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

  @observable
  String? _result;

  @computed
  String get result => _result ?? ColorblindTypes.normal;

  @computed
  bool get hasResult => _result != null;

  @computed
  bool get hasColorblind => result != ColorblindTypes.normal;

  @observable
  double? _percentage;

  @computed
  double get percentage => _percentage ?? 0;

  // actions:-------------------------------------------------------------------
  @action
  void changeAnswers(List<Answer> answers) {
    _answers.answers = answers;
    _answersRepository.changeAnswers(_answers);
  }

  @action
  void setResult(String result, percentage) {
    _result = result;
    _percentage = percentage;

    _answersRepository.setResult(result);
    _answersRepository.setResultPercentage(percentage);
  }

  // general:-------------------------------------------------------------------
  void init() async {
    if (_answersRepository.answers != null) {
      _answers = _answersRepository.answers!;
    }

    _result = _answersRepository.result;
    _percentage = _answersRepository.percentage;
  }
}