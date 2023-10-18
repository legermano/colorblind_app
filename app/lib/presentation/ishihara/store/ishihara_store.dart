import 'package:boilerplate/constants/colorblind_type.dart';
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

    String result = ColorblindTypes.undefined;
    double percentage = 0;

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

      result = ColorblindTypes.normal;
      percentage = (totalNormalAnswers / this.answers.length) * 100;

    } else if(normalCount <= 13) {
      double protanCount = 0;
      double deutanCount = 0;

      List<Answer> classificationAnswers = this.answers.where((answer) => answer.plate.order >= 22).toList();

      for (var i = 0; i < classificationAnswers.length; i++) {
        Answer answer = classificationAnswers[i];

        if(answer.answer == answer.plate.normal) {
          continue;
        }

        if(answer.answer == answer.plate.protanopia) {
          protanCount++;
        } else if (answer.answer == answer.plate.deuteranopia) {
          deutanCount++;
        } else if(answer.answer! >= 10) {
          String answerAsString = answer.answer.toString();

          if(answerAsString[0] == answer.plate.deuteranopia) {
            deutanCount = deutanCount + 0.5;
          } else if (answerAsString[1] == answer.plate.protanopia) {
            protanCount = protanCount + 0.5;
          }
        }
      }

      if(protanCount > deutanCount) {
        result = ColorblindTypes.protan;
        percentage = ((redGreenDeficiencyCount + protanCount) / this.answers.length) * 100;
      } else if (deutanCount > protanCount) {
        result = ColorblindTypes.deutan;
        percentage = ((redGreenDeficiencyCount + deutanCount) / this.answers.length) * 100;
      } else {
        result = ColorblindTypes.redGreen;
        percentage = ((redGreenDeficiencyCount + protanCount + deutanCount) / this.answers.length) * 100;
      }

    } else if(monocromaticCount >= 17) {
      result = ColorblindTypes.monocromatic;
      percentage = (this.answers.where((a) => a.cantSee == true).length / this.answers.length) * 100;
    }

    this.userStore.changeAnswers(this.answers);
    this.userStore.setResult(result, percentage);

    return true;
  }
}