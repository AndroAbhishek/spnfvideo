import 'dart:convert';

import 'package:SPNF/model/Languages.dart';
import 'package:SPNF/model/Audio_Model.dart';
import 'package:SPNF/model/Video_Model.dart';
import 'package:floor/floor.dart';

class VideoConvertor extends TypeConverter<List<Video_Model>, String> {
  @override
  List<Video_Model> decode(String databaseValue) {
    List list = json.decode(databaseValue);
    List<Video_Model> tags = [];
    list.map((value) {
      tags.add(Video_Model.fromJson(value));
    });
    return tags;
  }

  @override
  String encode(List<Video_Model>? value) {
    String v = json.encode(value);
    return v;
  }
}