import 'package:boilerplate/core/stores/error/error_store.dart';
import 'package:boilerplate/core/stores/user/user_store.dart';
import 'package:boilerplate/domain/entity/ishihara/answer.dart';
import 'package:boilerplate/domain/entity/ishihara/plate.dart';
import 'package:boilerplate/domain/entity/ishihara/plate_list.dart';
import 'package:boilerplate/domain/usecase/ishihara/get_plates_usercase.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'ishihara_store.g.dart';

class IshiharaStore = _IshiharaStore with _$IshiharaStore;

abstract class _IshiharaStore with Store {
  // constructor:---------------------------------------------------------------
  _IshiharaStore(
    this._getPlatesUseCase,
    this.errorStore,
    this.userStore,
  );

  // use cases:-----------------------------------------------------------------
  final GetPlatesUseCase _getPlatesUseCase;

  // stores:--------------------------------------------------------------------
  // store for handling errors
  final ErrorStore errorStore;

  final UserStore userStore;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<PlateList?> emptyPlateResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<PlateList?> fetchPlateListFuture =
      ObservableFuture<PlateList?>(emptyPlateResponse);

  @observable
  PlateList? plateList;

  @observable
  int currentPlate = 1;

  @observable
  List<Answer> answers = <Answer>[];

  @computed
  bool get platesLoading => fetchPlateListFuture.status == FutureStatus.pending;

  @computed
  bool get isLastPlate => currentPlate == platesQuantity;

  @computed
  int get platesQuantity => plateList?.plates?.length ?? 0;

  // actions:-------------------------------------------------------------------
  @action
  void resetTest() {
    currentPlate = 1;
    answers = [];
  }

  @action
  void nextPlate() {
    currentPlate++;
  }

  @action
  Future getPlates() async {
    final future = _getPlatesUseCase.call(params: null);
    fetchPlateListFuture = ObservableFuture(future);

    future.then((plateList) {
      this.plateList = plateList;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  void setAnswer(String answer, bool cantSee, [int? plateOrder]) {
    final int order = plateOrder ?? currentPlate;
    final int index = plateList?.plates?.indexWhere((plate) => plate.order == order) ?? -1;

    final Plate? plate = plateList?.plates?.elementAt(index);

    if(plate == null) {
      errorStore.errorMessage = "Prança não encontrada";
      return;
    }

    this.answers.add(new Answer(
      plate: plate,
      cantSee: answers.isEmpty ? true : cantSee,
      answer: (answer.isEmpty || cantSee ) ? null : int.parse(answer)
    ));
  }

  @action
  Future <bool> concludeTest() async {
    if(this.answers.length < this.platesQuantity) {
      errorStore.errorMessage = "Não é possível concluir o teste. Nem todas as pranchas foram respondidas";
      return false;
    }

    // Sort the answers
    this.answers.sort((a,b) => a.plate.order.compareTo(b.plate.order));

    List<Answer> cutoutAnswers = this.answers.takeWhile((answer) => answer.plate.order <= 21).toList();

    // Test the first 21 plates, verifying if the person has a red green deficiency or not
    int normalCount = 0;
    int monocromaticCount = 0;
    int redGreenDeficiencyCount = 0;

    cutoutAnswers.forEach((answer) {
      if(answer.cantSee) {
        monocromaticCount++;
      }

      if(answer.answer == answer.plate.normal) {
        normalCount++;

        if(answer.plate.order == 1) {
          monocromaticCount++;
        }
      }

      if(answer.answer == answer.plate.redGreenDeficiency) {
        redGreenDeficiencyCount++;
      }
    });

    if(normalCount >= 17) {
      // Normal view
      int totalNormalAnswers = 0;

      this.answers.forEach((a) {
        if(a.answer == a.plate.normal) {
          totalNormalAnswers++;
        }
       });

    } else if(normalCount <= 13) {
      // Red green deficiency

    } else {
      // Inconclusive for red green deficiency
    }

    this.userStore.changeAnswers(this.answers);

    return true;
  }
}