import 'package:boilerplate/domain/entity/ishihara/plate.dart';

class PlateList {
  final List<Plate>? plates;

  PlateList({
    this.plates,
  });

  factory PlateList.fromJson(List<dynamic> json) {
    List<Plate> plates = <Plate>[];
    plates = json.map((plate) => Plate.fromJson(plate)).toList();

    return PlateList(
      plates: plates
    );
  }
}
