import 'package:boilerplate/core/stores/error/error_store.dart';
import 'package:boilerplate/core/stores/form/form_store.dart';
import 'package:boilerplate/domain/usecase/user/register_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/usecase/user/login_usecase.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  // constructor:---------------------------------------------------------------
  _LoginStore(
    this._loginUseCase,
    this._registerUseCase,
    this.formErrorStore,
    this.errorStore,
  ) {
    // setting up disposers
    _setupDisposers();

    // checking if user is logged in
    this.user = FirebaseAuth.instance.currentUser;
  }

  // use cases:-----------------------------------------------------------------
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  // stores:--------------------------------------------------------------------
  // for handling form errors
  final FormErrorStore formErrorStore;

  // store for handling error messages
  final ErrorStore errorStore;

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _setupDisposers() {
    _disposers = [
      reaction((_) => success, (_) => success = false, delay: 200),
    ];
  }

  // empty responses:-----------------------------------------------------------
  static ObservableFuture<User?> emptyLoginResponse =
      ObservableFuture.value(null);

  static ObservableFuture<User?> emptyRegisterResponse =
      ObservableFuture.value(null);

  // store variables:-----------------------------------------------------------
  @observable
  User? user;

  @observable
  bool success = false;

  @observable
  ObservableFuture<User?> loginFuture = emptyLoginResponse;

  @observable
  ObservableFuture<User?> registerFuture = emptyRegisterResponse;

  @computed
  bool get isLoading => loginFuture.status == FutureStatus.pending;

  @computed
  bool get isLoggedIn => this.user != null;

  // actions:-------------------------------------------------------------------
  @action
  Future login(String email, String password) async {
    final LoginParams loginParams =
        LoginParams(email: email, password: password);
    final future = _loginUseCase.call(params: loginParams);
    loginFuture = ObservableFuture(future);

    await future.then((value) async {
      if (value != null) {
        this.user = value;
        this.success = true;
      }
    }).catchError((e) {
      print(e);
      this.success = false;
      throw e;
    });
  }

  @action
  Future register(String name, String email, String password) async {
    final RegisterParams registerParams =
        RegisterParams(name: name, email: email, password: password);
    final future = _registerUseCase.call(params: registerParams);
    registerFuture = ObservableFuture(future);

    await future.then((value) async {
      if (value != null) {
        this.user = value;
        this.success = true;
      }
    }).catchError((e) {
      print(e);
      this.success = false;
      throw e;
    });
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    this.user = null;
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
