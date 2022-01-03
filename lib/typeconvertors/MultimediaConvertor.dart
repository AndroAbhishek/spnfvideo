
import 'dart:convert';
import 'package:SPNF/model/Multimedia.dart';
import 'package:floor/floor.dart';

class MultimediaConvertor extends TypeConverter<List<Multimedia>, String> {
  @override
  List<Multimedia> decode(String databaseValue) {
    List list = json.decode(databaseValue);
    List<Multimedia> tags = [];
    list.map((value) {
      tags.add(Multimedia.fromJson(value));
    });
    return tags;
  }

  @override
  String encode(List<Multimedia>? value) {
    String v = json.encode(value);
    return v;
  }
}