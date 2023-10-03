import 'dart:async';

import 'package:boilerplate/core/domain/usecase/use_case.dart';
import 'package:boilerplate/domain/entity/ishihara/plate_list.dart';
import 'package:boilerplate/domain/repository/ishihara/ishihara_plates_repository.dart';

class GetPlatesUseCase extends UseCase<PlateList, void> {
  final IshiharaPlatesRepository _ishiharaPlatesRepository;

  GetPlatesUseCase(this._ishiharaPlatesRepository);

  @override
  Future<PlateList> call({required void params}) {
    return _ishiharaPlatesRepository.getPlates();
  }
}