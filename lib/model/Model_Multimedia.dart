import 'package:SPNF/model/Json_List.dart';
import 'package:floor/floor.dart';



/*
class Model_Multimedia {
  @PrimaryKey(autoGenerate: false)
  String? version;
  late List<Data> data ;
  late List<Languages> languages ;
  Model_Multimedia(
      {this.version,
        required this.data,
        required this.languages
      });


  Model_Multimedia.fromJson(Map<String, dynamic> json) {
    data= json['data'];
    languages= json['languages'];
    version= json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['languages'] = this.languages;
    data['version'] = this.version;
    return data;
  }

}
*/

const String MULTIMEDIA_STRING_TABLE_NAME = 'multimedia_string';

@Entity(tableName:MULTIMEDIA_STRING_TABLE_NAME)
class Model_Multimedia {
  Model_Multimedia({
    required this.json_id,
    required this.jsonData,
  });
  @PrimaryKey(autoGenerate: false)
  int? json_id;
  String? jsonData;

  factory Model_Multimedia.fromJson(String jsonId,dynamic json) {
    return Model_Multimedia(
        json_id: int.parse(jsonId),
        jsonData: json, );

  }

  @override
  String toString() {
    return '{${this.jsonData} }';
  }


  /*factory Model_Multimedia.fromJson(Map<String, dynamic> json) => Model_Multimedia(
    json_id: 0,
    jsonData: json["languages"] == null ? [] : List<Languages>.from(json["languages"].map((x) => Languages.fromJson(x))),

  );*/



}


/*import 'package:floor/floor.dart';

import 'Languages.dart';
import 'Datum.dart';

const String MULTIMEDIA_TABLE_NAME = 'multimedia';

@Entity(tableName:MULTIMEDIA_TABLE_NAME)
class Model_Multimedia {


 Model_Multimedia({
      int? id,
      String? version, 
      List<Languages>? languages,
      List<Data>? data}){
    _id = id;
    _version = version;
    _languages = languages?? [];
    _data = data?? [];
}

 @PrimaryKey(autoGenerate: true)
 int? _id =0;
 String? _version;
 List<Data> _data= [] ;
 List<Languages> _languages =[];

 Model_Multimedia.fromJson(dynamic json) {
    _version = json['version'];
    if (json['languages'] != null) {
      _languages = [];
      json['languages'].forEach((v) {
        _languages.add(Languages.fromJson(v));
      });
    }
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }





  String? get version => _version;
  int? get id => _id;
  List<Languages>? get languages => _languages;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['version'] = _version;
    if (_languages != null) {
      map['languages'] = _languages.map((v) => v.toJson()).toList();
    }
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}*/
