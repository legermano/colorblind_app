import 'dart:convert';

import 'package:boilerplate/domain/entity/ishihara/plate_list.dart';
import 'package:flutter/services.dart';

class IshiharaPlatesApi {
  Future<PlateList> getPlates() async {
    try {
      String jsonString = await rootBundle.loadString('assets/json/plates.json');
      var jsonMap = json.decode(jsonString);

      return PlateList.fromJson(jsonMap);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}