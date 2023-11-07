import 'dart:async';

import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/domain/usecase/user/login_usecase.dart';
import 'package:boilerplate/domain/usecase/user/register_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImpl extends UserRepository {
  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  UserRepositoryImpl(this._sharedPrefsHelper);

  // Login:---------------------------------------------------------------------
  @override
  Future<User?> login(LoginParams params) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: params.email, password: params.password);

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

      throw e;
    }
  }

  // Register:------------------------------------------------------------------
  @override
  Future<User?> register(RegisterParams params) async {
    try {
      final credentail = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: params.email, password: params.password);

      await credentail.user?.updateDisplayName(params.name);

      return credentail.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }

      throw e;
    } catch (e) {
      print(e);

      throw e;
    }
  }

  @override
  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  @override
  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;

  @override
  Future<void> saveShowOnboarding(bool value) =>
      _sharedPrefsHelper.saveShowOnboarding(value);

  @override
  Future<bool> get showOnboarding => _sharedPrefsHelper.showOnboarding;
}
