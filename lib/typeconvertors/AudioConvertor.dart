import 'dart:convert';

import 'package:SPNF/model/Audio_Model.dart';
import 'package:floor/floor.dart';

class AudioConvertor extends TypeConverter<List<Audio_Model>, String> {
  @override
  List<Audio_Model> decode(String databaseValue) {
    List list = json.decode(databaseValue);
    List<Audio_Model> tags = [];
    list.map((value) {
      tags.add(Audio_Model.fromJson(value));
    });
    return tags;
  }

  @override
  String encode(List<Audio_Model>? value) {
    String v = json.encode(value);
    return v;
  }
}