import 'package:boilerplate/core/domain/usecase/use_case.dart';
import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginGoogleUseCase implements UseCase<User?, void> {
  final UserRepository _userRepository;

  LoginGoogleUseCase(this._userRepository);

  @override
  Future<User?> call({required void params}) async {
    return _userRepository.loginGoogle();
  }
}