import 'package:boilerplate/core/stores/error/error_store.dart';
import 'package:boilerplate/core/stores/form/form_store.dart';
import 'package:boilerplate/core/stores/user/user_store.dart';
import 'package:boilerplate/di/service_locator.dart';
import 'package:boilerplate/domain/usecase/user/login_anonymously_usecase.dart';
import 'package:boilerplate/domain/usecase/user/login_google_usecase.dart';
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
    this._loginGoogleUseCase,
    this._loginAnonymouslyUseCase,
    this._registerUseCase,
    this.formErrorStore,
    this.errorStore,
  ) {
    // setting up disposers
    _setupDisposers();

    // checking if user is logged in
    this.user = FirebaseAuth.instance.currentUser;
    this.isLoggedIn = this.user != null;
  }

  // use cases:-----------------------------------------------------------------
  final LoginUseCase _loginUseCase;
  final LoginGoogleUseCase _loginGoogleUseCase;
  final LoginAnonymouslyUseCase _loginAnonymouslyUseCase;
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
  bool isLoggedIn = false;

  @observable
  bool success = false;

  @observable
  ObservableFuture<User?> loginFuture = emptyLoginResponse;

  @observable
  ObservableFuture<User?> registerFuture = emptyRegisterResponse;

  @computed
  bool get isLoading => loginFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future login(String email, String password) async {
    final LoginParams loginParams =
        LoginParams(email: email, password: password);
    final future = _loginUseCase.call(params: loginParams);
    loginFuture = ObservableFuture(future);

    await future.then((value) async {
      if (value != null) {
        _login(value);
      }
    }).catchError((e) {
      print(e);
      this.success = false;
      throw e;
    });
  }

  @action
  Future loginGoogle() async {
    final future = _loginGoogleUseCase.call(params: null);
    loginFuture = ObservableFuture(future);

    await future.then((value) async {
      if (value != null) {
        _login(value);
      }
    }).catchError((e) {
      print(e);
      this.success = false;
      throw e;
    });
  }

  @action
  Future loginAnonymously() async {
    final future = _loginAnonymouslyUseCase.call(params: null);
    loginFuture = ObservableFuture(future);

    await future.then((value) async {
      if (value != null) {
        _login(value);
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
        _login(value);
      }
    }).catchError((e) {
      print(e);
      this.success = false;
      throw e;
    });
  }

  _login(User user) {
    this.user = user;
    this.isLoggedIn = true;
    this.success = true;

    final UserStore _userStore = getIt<UserStore>();
    _userStore.init();
  }

  logout() async {
    this.user = null;
    this.isLoggedIn = false;
    FirebaseAuth.instance.signOut();

    final UserStore _userStore = getIt<UserStore>();
    _userStore.clear();
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
