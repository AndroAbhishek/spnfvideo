import 'package:SPNF/model/Audio_Model.dart';
import 'package:SPNF/model/Video_Model.dart';
import 'package:floor/floor.dart';


const String DATA_TABLE_NAME = 'Data';

// @Entity(tableName:DATA_TABLE_NAME)
class Datum {
  Datum({
    required this.id,
    required this.audio,
    required this.video,
  });


  // @PrimaryKey(autoGenerate: false)
  String id;
  List<Audio_Model> audio =[];
  List<Video_Model> video= [];

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    audio: json["audio"] == null ? [] : List<Audio_Model>.from(json["audio"].map((x) => Audio_Model.fromJson(x))).toList(growable: true),
    video: json["video"] == null ? [] : List<Video_Model>.from(json["video"].map((x) => Video_Model.fromJson(x))).toList(growable: true),
  );



  Map<String, dynamic> toJson() => {
    "id": id,
    "audio": audio == null ? null : List<dynamic>.from(audio.map((x) => x.toJson())),
    "video": List<dynamic>.from(video.map((x) => x.toJson())),
  };
}
/*
class Data {
  Data({
      required String id,
      required List<Audio_Model> audio,
      required List<Video_Model> video}){
    _id = id;
    _audio = audio;
    _video = video;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    if (json['audio'] != null) {
      _audio = [];
      json['audio'].forEach((v) {
        _audio?.add(Audio_Model.fromJson(v));
      });
    }
    if (json['video'] != null) {
      _video = [];
      json['video'].forEach((v) {
        _video.add(Video_Model.fromJson(v));
      });
    }
  }
  @PrimaryKey(autoGenerate: false)
  String? _id;
  List<Audio_Model> _audio =[];
  List<Video_Model> _video =[];

  String? get id => _id;
  List<Audio_Model>? get audio => _audio;
  List<Video_Model>? get video => _video;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_audio != null) {
      map['audio'] = _audio.map((v) => v.toJson()).toList();
    }
    if (_video != null) {
      map['video'] = _video.map((v) => v.toJson()).toList();
    }
    return map;
  }
*/


