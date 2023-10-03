import 'package:boilerplate/domain/usecase/user/save_show_onboarding_usecase.dart';
import 'package:boilerplate/domain/usecase/user/show_onboarding_usecase.dart';
import 'package:mobx/mobx.dart';

part 'onboarding_store.g.dart';

class OnboardingStore = _OnboardingStore with _$OnboardingStore;

abstract class _OnboardingStore with Store {
  // constructor
  _OnboardingStore(
    this._showOnboardingUseCase,
    this._saveShowOnboardingUseCase,
  ) {
    // checking if needs to show onboarding for the user
    _showOnboardingUseCase.call(params: null).then((value) async {
      showOnboarding = value;
    });
  }

  // use cases
  final ShowOnboardingUseCase _showOnboardingUseCase;
  final SaveShowOnboardingUseCase _saveShowOnboardingUseCase;

  // store variables
  bool showOnboarding = true;

  @action
  Future complete() async {
    await _saveShowOnboardingUseCase.call(params: false);
    this.showOnboarding = false;
  }
}