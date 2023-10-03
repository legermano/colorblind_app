import 'dart:async';

import 'package:boilerplate/core/domain/usecase/use_case.dart';
import 'package:boilerplate/domain/repository/user/user_repository.dart';

class ShowOnboardingUseCase implements UseCase<bool, void> {
  final UserRepository _userRepository;

  ShowOnboardingUseCase(this._userRepository);

  @override
  Future<bool> call({required void params}) async {
    return await _userRepository.showOnboarding;
  }

}