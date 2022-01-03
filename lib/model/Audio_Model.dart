import 'package:floor/floor.dart';


/*@Entity(tableName:'Audio_Model')
class Audio_Model {
  @PrimaryKey(autoGenerate: true)
  int? audio_id;
  String? title;
  String? url;
  Audio_Model(
      {this.audio_id,
        this.title,
        this.url});
}*/

// @Entity(tableName:'Audio_Model')
class Audio_Model {
  Audio_Model({
    required this.audio_id,
    required this.title,
    required this.url,
  });

  // @PrimaryKey(autoGenerate: true)
  int audio_id;
  String title;
  String url;

  factory Audio_Model.fromJson(Map<String, dynamic> json) => Audio_Model(
    title: json["title"],
    url: json["URL"],
    audio_id: 0,
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "URL": url,
  };
}



/*class Audio_Model {
  Audio_Model({
      required int id,
      String? title,
      String? url,}){
    _audio_id =id;
    _title = title;
    _url = url;
}

  Audio_Model.fromJson(dynamic json) {
    _title = json['title'];
    _url = json['URL'];
  }
  @PrimaryKey(autoGenerate: true)
  int _audio_id = 0;
  String? _title;
  String? _url;

  String? get title => _title;
  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['URL'] = _url;
    return map;
  }

}*/
