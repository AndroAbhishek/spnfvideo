
import 'dart:convert';
import 'package:SPNF/model/Datum.dart';
import 'package:floor/floor.dart';

class DataConvertor extends TypeConverter<List<Datum>, String> {
  @override
  List<Datum> decode(String databaseValue) {
    List list = json.decode(databaseValue);
    List<Datum> tags = [];
    list.map((value) {
      tags.add(Datum.fromJson(value));
    });
    return tags;
  }

  @override
  String encode(List<Datum>? value) {
    String v = json.encode(value);
    return v;
  }
}