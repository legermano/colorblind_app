import 'dart:async';

import 'package:boilerplate/domain/usecase/user/login_usecase.dart';
import 'package:boilerplate/domain/usecase/user/register_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<User?> login(LoginParams params);

  Future<User?> register(RegisterParams params);

  Future<void> saveIsLoggedIn(bool value);

  Future<void> saveShowOnboarding(bool value);

  Future<bool> get isLoggedIn;

  Future<bool> get showOnboarding;

}
