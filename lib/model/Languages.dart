import 'package:floor/floor.dart';


const String LANGUAGES_TABLE_NAME = 'Languages';

// @Entity(tableName:'Languages')
class Languages {
  Languages({
    required this.id,
    required this.name,
  });

  // @PrimaryKey(autoGenerate: false)
  String id;
  String name;

  factory Languages.fromJson(Map<String, dynamic> json) => Languages(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}



/*class Languages {
  Languages({
      required String id,
      String? name,}){
    _id = id;
    _name = name;
}

  Languages.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  @PrimaryKey(autoGenerate: false)
  String? _id;
  String? _name;

  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}*/
