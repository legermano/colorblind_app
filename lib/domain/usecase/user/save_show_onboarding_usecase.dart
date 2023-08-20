import 'dart:async';

import 'package:boilerplate/core/domain/usecase/use_case.dart';
import 'package:boilerplate/domain/repository/user/user_repository.dart';

class SaveShowOnboardingUseCase implements UseCase<void, bool> {
  final UserRepository _userRepository;

  SaveShowOnboardingUseCase(this._userRepository);

  @override
  FutureOr<void> call({required bool params}) async {
    return _userRepository.saveShowOnboarding(params);
  }
  
} 