import 'package:boilerplate/data/network/apis/ishihara/ishihara_plates_api.dart';
import 'package:boilerplate/domain/entity/ishihara/plate_list.dart';
import 'package:boilerplate/domain/repository/ishihara/ishihara_plates_repository.dart';

class IshiharaPlatesRepositoryImpl extends IshiharaPlatesRepository {
  final IshiharaPlatesApi _ishiharaPlatesApi;

  IshiharaPlatesRepositoryImpl(this._ishiharaPlatesApi);

  // Ishihara plates: ------------------------------------------------------
  Future<PlateList> getPlates() async {
    return await _ishiharaPlatesApi.getPlates()
      .then((platesList) => platesList)
      .catchError((error) => throw error);
  }
}