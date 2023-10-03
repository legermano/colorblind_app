// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ishihara_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IshiharaStore on _IshiharaStore, Store {
  Computed<bool>? _$platesLoadingComputed;

  @override
  bool get platesLoading =>
      (_$platesLoadingComputed ??= Computed<bool>(() => super.platesLoading,
              name: '_IshiharaStore.platesLoading'))
          .value;
  Computed<bool>? _$isLastPlateComputed;

  @override
  bool get isLastPlate =>
      (_$isLastPlateComputed ??= Computed<bool>(() => super.isLastPlate,
              name: '_IshiharaStore.isLastPlate'))
          .value;
  Computed<int>? _$platesQuantityComputed;

  @override
  int get platesQuantity =>
      (_$platesQuantityComputed ??= Computed<int>(() => super.platesQuantity,
              name: '_IshiharaStore.platesQuantity'))
          .value;

  late final _$fetchPlateListFutureAtom =
      Atom(name: '_IshiharaStore.fetchPlateListFuture', context: context);

  @override
  ObservableFuture<PlateList?> get fetchPlateListFuture {
    _$fetchPlateListFutureAtom.reportRead();
    return super.fetchPlateListFuture;
  }

  @override
  set fetchPlateListFuture(ObservableFuture<PlateList?> value) {
    _$fetchPlateListFutureAtom.reportWrite(value, super.fetchPlateListFuture,
        () {
      super.fetchPlateListFuture = value;
    });
  }

  late final _$plateListAtom =
      Atom(name: '_IshiharaStore.plateList', context: context);

  @override
  PlateList? get plateList {
    _$plateListAtom.reportRead();
    return super.plateList;
  }

  @override
  set plateList(PlateList? value) {
    _$plateListAtom.reportWrite(value, super.plateList, () {
      super.plateList = value;
    });
  }

  late final _$currentPlateAtom =
      Atom(name: '_IshiharaStore.currentPlate', context: context);

  @override
  int get currentPlate {
    _$currentPlateAtom.reportRead();
    return super.currentPlate;
  }

  @override
  set currentPlate(int value) {
    _$currentPlateAtom.reportWrite(value, super.currentPlate, () {
      super.currentPlate = value;
    });
  }

  late final _$answersAtom =
      Atom(name: '_IshiharaStore.answers', context: context);

  @override
  List<Answer> get answers {
    _$answersAtom.reportRead();
    return super.answers;
  }

  @override
  set answers(List<Answer> value) {
    _$answersAtom.reportWrite(value, super.answers, () {
      super.answers = value;
    });
  }

  late final _$getPlatesAsyncAction =
      AsyncAction('_IshiharaStore.getPlates', context: context);

  @override
  Future<dynamic> getPlates() {
    return _$getPlatesAsyncAction.run(() => super.getPlates());
  }

  late final _$concludeTestAsyncAction =
      AsyncAction('_IshiharaStore.concludeTest', context: context);

  @override
  Future<bool> concludeTest() {
    return _$concludeTestAsyncAction.run(() => super.concludeTest());
  }

  late final _$_IshiharaStoreActionController =
      ActionController(name: '_IshiharaStore', context: context);

  @override
  void resetTest() {
    final _$actionInfo = _$_IshiharaStoreActionController.startAction(
        name: '_IshiharaStore.resetTest');
    try {
      return super.resetTest();
    } finally {
      _$_IshiharaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextPlate() {
    final _$actionInfo = _$_IshiharaStoreActionController.startAction(
        name: '_IshiharaStore.nextPlate');
    try {
      return super.nextPlate();
    } finally {
      _$_IshiharaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAnswer(String answer, bool cantSee, [int? plateOrder]) {
    final _$actionInfo = _$_IshiharaStoreActionController.startAction(
        name: '_IshiharaStore.setAnswer');
    try {
      return super.setAnswer(answer, cantSee, plateOrder);
    } finally {
      _$_IshiharaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchPlateListFuture: ${fetchPlateListFuture},
plateList: ${plateList},
currentPlate: ${currentPlate},
answers: ${answers},
platesLoading: ${platesLoading},
isLastPlate: ${isLastPlate},
platesQuantity: ${platesQuantity}
    ''';
  }
}
