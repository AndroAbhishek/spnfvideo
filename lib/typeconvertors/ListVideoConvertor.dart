import 'dart:convert';

import 'package:SPNF/model/Audio_Model.dart';
import 'package:SPNF/model/List_Video.dart';
import 'package:floor/floor.dart';

class ListVideoConvertor extends TypeConverter<List<List_Video>, String> {
  @override
  List<List_Video> decode(String databaseValue) {
    List list = json.decode(databaseValue);
    List<List_Video> tags = [];
    list.map((value) {
      tags.add(List_Video.fromJson(value));
    });
    return tags;
  }

  @override
  String encode(List<List_Video>? value) {
    String v = json.encode(value);
    return v;
  }
}