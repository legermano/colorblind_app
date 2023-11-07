import 'dart:async';

import 'package:boilerplate/core/stores/error/error_store.dart';
import 'package:boilerplate/core/stores/form/form_store.dart';
import 'package:boilerplate/core/stores/user/user_store.dart';
import 'package:boilerplate/domain/repository/ishihara/ishihara_answers_repository.dart';
import 'package:boilerplate/domain/usecase/ishihara/get_plates_usercase.dart';
import 'package:boilerplate/domain/usecase/user/register_usecase.dart';
import 'package:boilerplate/presentation/ishihara/store/ishihara_store.dart';
import 'package:boilerplate/domain/repository/setting/setting_repository.dart';
import 'package:boilerplate/domain/usecase/post/get_post_usecase.dart';
import 'package:boilerplate/domain/usecase/user/login_usecase.dart';
import 'package:boilerplate/domain/usecase/user/save_show_onboarding_usecase.dart';
import 'package:boilerplate/domain/usecase/user/show_onboarding_usecase.dart';
import 'package:boilerplate/presentation/home/store/language/language_store.dart';
import 'package:boilerplate/presentation/home/store/theme/theme_store.dart';
import 'package:boilerplate/presentation/login/store/login_store.dart';
import 'package:boilerplate/presentation/onboarding/store/onboarding_store.dart';
import 'package:boilerplate/presentation/post/store/post_store.dart';

import '../../../di/service_locator.dart';

mixin StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());
    getIt.registerFactory(() => FormErrorStore());
    getIt.registerFactory(
      () => FormStore(getIt<FormErrorStore>(), getIt<ErrorStore>()),
    );

    // stores:------------------------------------------------------------------
    getIt.registerSingleton<LoginStore>(
      LoginStore(
        getIt<LoginUseCase>(),
        getIt<RegisterUseCase>(),
        getIt<FormErrorStore>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<PostStore>(
      PostStore(
        getIt<GetPostUseCase>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<ThemeStore>(
      ThemeStore(
        getIt<SettingRepository>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<LanguageStore>(
      LanguageStore(
        getIt<SettingRepository>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<UserStore>(
      UserStore(
        getIt<IshiharaAnswersRepository>(),
      )
    );

    getIt.registerSingleton<OnboardingStore>(
      OnboardingStore(
        getIt<ShowOnboardingUseCase>(),
        getIt<SaveShowOnboardingUseCase>(),
      ),
    );

    getIt.registerSingleton<IshiharaStore>(
      IshiharaStore(
        getIt<GetPlatesUseCase>(),
        getIt<ErrorStore>(),
        getIt<UserStore>(),
      )
    );
  }
}
