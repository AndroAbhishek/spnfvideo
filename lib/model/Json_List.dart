import 'package:floor/floor.dart';


const String Json_List_TABLE_NAME = 'abc';

@Entity(tableName : Json_List_TABLE_NAME)
class Json_List {
  Json_List({
    this.ddd,
    required this.name,
  });

   @PrimaryKey(autoGenerate: false)
  int? ddd;
  String name;

  factory Json_List.fromJson(Map<String, dynamic> json) => Json_List(
    name: json[0],
  );

  Map<String, dynamic> toJson() => {
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
