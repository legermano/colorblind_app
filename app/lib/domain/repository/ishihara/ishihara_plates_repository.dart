import 'package:boilerplate/domain/entity/ishihara/plate_list.dart';

abstract class IshiharaPlatesRepository {
  Future<PlateList> getPlates();
}