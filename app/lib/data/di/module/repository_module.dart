import 'dart:async';

import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/network/apis/ishihara/ishihara_plates_api.dart';
import 'package:boilerplate/data/network/apis/posts/post_api.dart';
import 'package:boilerplate/data/repository/ishihara/ishihara_answers_repository_impl.dart';
import 'package:boilerplate/data/repository/ishihara/ishihara_plates_repository_impl.dart';
import 'package:boilerplate/data/repository/post/post_repository_impl.dart';
import 'package:boilerplate/data/repository/setting/setting_repository_impl.dart';
import 'package:boilerplate/data/repository/user/user_repository_impl.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/domain/repository/ishihara/ishihara_answers_repository.dart';
import 'package:boilerplate/domain/repository/ishihara/ishihara_plates_repository.dart';
import 'package:boilerplate/domain/repository/post/post_repository.dart';
import 'package:boilerplate/domain/repository/setting/setting_repository.dart';
import 'package:boilerplate/domain/repository/user/user_repository.dart';

import '../../../di/service_locator.dart';

mixin RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    // repository:--------------------------------------------------------------
    getIt.registerSingleton<SettingRepository>(SettingRepositoryImpl(
      getIt<SharedPreferenceHelper>(),
    ));

    getIt.registerSingleton<UserRepository>(UserRepositoryImpl(
      getIt<SharedPreferenceHelper>(),
    ));

    getIt.registerSingleton<PostRepository>(PostRepositoryImpl(
      getIt<PostApi>(),
      getIt<PostDataSource>(),
    ));

    getIt.registerSingleton<IshiharaPlatesRepository>(IshiharaPlatesRepositoryImpl(
      getIt<IshiharaPlatesApi>(),
    ));

    getIt.registerSingleton<IshiharaAnswersRepository>(IshiharaAnswersRepositoryImpl(
      getIt<SharedPreferenceHelper>()
    ));
  }
}
