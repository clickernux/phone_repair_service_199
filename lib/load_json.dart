import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:phone_repair_service_199/model/ussd.dart';

class LoadJson {
  static Future<List<Ussd>> ussdCodes(String name) async {
    final dataString = await rootBundle.loadString('assets/ussd_code.json');
    final Map<String, dynamic> data = await json.decode(dataString);
    final bool isDataExist = data.containsKey(name.toLowerCase());
    if (isDataExist) {
      final List<Ussd> ussdCodes = [];
      final dataList = data[name.toLowerCase()];
      for (var element in dataList) {
        ussdCodes.add(Ussd.fromJson(element));
      }

      return ussdCodes;
    }
    return Future.error('No Data for $name');
  }
}
