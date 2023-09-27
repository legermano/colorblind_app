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
  String toString() {
    return '''
answers: ${answers}
    ''';
  }
}
