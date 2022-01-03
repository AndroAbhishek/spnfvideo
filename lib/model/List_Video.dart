import 'package:floor/floor.dart';

// @Entity(tableName:'List_Video')
class List_Video {
  List_Video({
    required this.youtubevid,
    required this.title,
  });

  // @PrimaryKey(autoGenerate: false)
  String youtubevid;
  String title;

  factory List_Video.fromJson(Map<String, dynamic> json) => List_Video(
    youtubevid: json["youtubevid"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "youtubevid": youtubevid,
    "title": title,
  };
}





/*class List_Video {
  List_Video({
      required String youtubevid,
      String? title,}){
    _youtubevid = youtubevid;
    _title = title;
}

  List_Video.fromJson(dynamic json) {
    _youtubevid = json['youtubevid'];
    _title = json['title'];
  }
  @PrimaryKey(autoGenerate: false)
  String? _youtubevid;
  String? _title;

  String? get youtubevid => _youtubevid;
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['youtubevid'] = _youtubevid;
    map['title'] = _title;
    return map;
  }

}*/
