import 'dart:convert';

import 'package:SPNF/model/Languages.dart';
import 'package:floor/floor.dart';

class LanguageConvertor extends TypeConverter<List<Languages>, String> {
  @override
  List<Languages> decode(String databaseValue) {
    List list = json.decode(databaseValue);
    List<Languages> tags = [];
    list.map((value) {
      tags.add(Languages.fromJson(value));
    });
    return tags;
  }

  @override
  String encode(List<Languages>? value) {
    String v = json.encode(value);
    return v;
  }
}