import 'package:boilerplate/constants/colorblind_type.dart';
import 'package:boilerplate/domain/entity/ishihara/answer.dart';
import 'package:boilerplate/domain/entity/ishihara/answer_list.dart';
import 'package:boilerplate/domain/repository/ishihara/ishihara_answers_repository.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:mobx/mobx.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final IshiharaAnswersRepository _answersRepository;
  final LoginStore _loginStore;

  // constructor:---------------------------------------------------------------
  _UserStore(this._answersRepository, this._loginStore) {
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
    _answersRepository.setAnswers(_loginStore.user!.uid, _answers);
  }

  @action
  void setResult(String result, percentage) {
    _result = result;
    _percentage = percentage;

    _answersRepository.setResult(_loginStore.user!.uid, result);
    _answersRepository.setResultPercentage(_loginStore.user!.uid, percentage);
  }

  // general:-------------------------------------------------------------------
  void init() async {
    if(_loginStore.user == null) {
      return;
    }

    final answers = await _answersRepository.getAnswers(_loginStore.user!.uid);

    if (answers != null) {
      _answers = answers;
    }

    _result = await _answersRepository.getResult(_loginStore.user!.uid);
    _percentage = await _answersRepository.getPercentage(_loginStore.user!.uid);
  }

  void clear() {
    _answers = AnswerList();
    _result = null;
    _percentage = null;
  }
}