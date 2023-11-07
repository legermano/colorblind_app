// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  Computed<List<Answer>>? _$answersComputed;

  @override
  List<Answer> get answers =>
      (_$answersComputed ??= Computed<List<Answer>>(() => super.answers,
              name: '_UserStore.answers'))
          .value;
  Computed<String>? _$resultComputed;

  @override
  String get result => (_$resultComputed ??=
          Computed<String>(() => super.result, name: '_UserStore.result'))
      .value;
  Computed<bool>? _$hasResultComputed;

  @override
  bool get hasResult => (_$hasResultComputed ??=
          Computed<bool>(() => super.hasResult, name: '_UserStore.hasResult'))
      .value;
  Computed<bool>? _$hasColorblindComputed;

  @override
  bool get hasColorblind =>
      (_$hasColorblindComputed ??= Computed<bool>(() => super.hasColorblind,
              name: '_UserStore.hasColorblind'))
          .value;
  Computed<double>? _$percentageComputed;

  @override
  double get percentage =>
      (_$percentageComputed ??= Computed<double>(() => super.percentage,
              name: '_UserStore.percentage'))
          .value;

  late final _$_answersAtom =
      Atom(name: '_UserStore._answers', context: context);

  @override
  AnswerList get _answers {
    _$_answersAtom.reportRead();
    return super._answers;
  }

  @override
  set _answers(AnswerList value) {
    _$_answersAtom.reportWrite(value, super._answers, () {
      super._answers = value;
    });
  }

  late final _$_resultAtom = Atom(name: '_UserStore._result', context: context);

  @override
  String? get _result {
    _$_resultAtom.reportRead();
    return super._result;
  }

  @override
  set _result(String? value) {
    _$_resultAtom.reportWrite(value, super._result, () {
      super._result = value;
    });
  }

  late final _$_percentageAtom =
      Atom(name: '_UserStore._percentage', context: context);

  @override
  double? get _percentage {
    _$_percentageAtom.reportRead();
    return super._percentage;
  }

  @override
  set _percentage(double? value) {
    _$_percentageAtom.reportWrite(value, super._percentage, () {
      super._percentage = value;
    });
  }

  late final _$_UserStoreActionController =
      ActionController(name: '_UserStore', context: context);

  @override
  void changeAnswers(List<Answer> answers) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.changeAnswers');
    try {
      return super.changeAnswers(answers);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setResult(String result, dynamic percentage) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.setResult');
    try {
      return super.setResult(result, percentage);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
answers: ${answers},
result: ${result},
hasResult: ${hasResult},
hasColorblind: ${hasColorblind},
percentage: ${percentage}
    ''';
  }
}
