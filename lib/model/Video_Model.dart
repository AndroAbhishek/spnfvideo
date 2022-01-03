import 'package:SPNF/model/List_Video.dart';
import 'package:floor/floor.dart';



// @Entity(tableName:'Video_Model')
class Video_Model {
  Video_Model({
    required this.id,
    required this.heading,
    required this.list,
  });

  // @PrimaryKey(autoGenerate: true)
  int id;
  String heading;
  List<List_Video> list =[];

  factory Video_Model.fromJson(Map<String, dynamic> json) => Video_Model(
    heading: json["heading"],
    /*list: List<List_Video>.from(json["list"].map((i) => List_Video.fromJson(i))).toList(),*/
    list: List<List_Video>.from(json["list"].map((x) => List_Video.fromJson(x))).toList(growable: true),
    id: 0,
  );

  Map<String, dynamic> toJson() => {
    "heading": heading,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

/*class Video_Model {
  Video_Model({
      required int id,
      String? heading, 
      required List<List_Video> list,}){
     _id= id;
    _heading = heading;
    _list = list;
}

  Video_Model.fromJson(dynamic json) {
    _heading = json['heading'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(List_Video.fromJson(v));
      });
    }
  }
  @PrimaryKey(autoGenerate: true)
  int _id = 0;
  String? _heading;
  List<List_Video> _list =[];

  String? get heading => _heading;
  List<List_Video>? get list => _list;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['heading'] = _heading;
    if (_list != null) {
      map['list'] = _list.map((v) => jsonEncode(v)).toList();
    }
    return map;
  }

}*/
