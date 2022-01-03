// To parse this JSON data, do
//
//     final multimedia = multimediaFromJson(jsonString);

import 'dart:convert';

import 'package:SPNF/model/Datum.dart';
import 'package:SPNF/model/Languages.dart';
import 'package:floor/floor.dart';

/*Multimedia multimediaFromJson(String str) => Multimedia.fromJson(json.decode(str));

String multimediaToJson(Multimedia data) => json.encode(data.toJson());*/

const String MULTIMEDIA_TABLE_NAME = 'multimedia';

@Entity(tableName:MULTIMEDIA_TABLE_NAME)
class Multimedia {
  Multimedia({
    required this.version,
    required this.languages,
    required this.data,
  });
  @PrimaryKey(autoGenerate: false)
  String version;
  List<Languages> languages;
  List<Datum> data;

  factory Multimedia.fromJson(Map<String, dynamic> json) => Multimedia(
    version: json["version"],
    languages: json["languages"] == null ? [] : List<Languages>.from(json["languages"].map((x) => Languages.fromJson(x))).toList(growable: true),
    data: json["data"] == null ? [] :  List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))).toList(growable: true),
  );


  Map<String, dynamic> toJson() => {
    "version": version,
    "languages": List<dynamic>.from(languages.map((x) => x.toJson())),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

/*class Datum {
  Datum({
    required this.id,
    required this.audio,
    required this.video,
  });

  String id;
  List<Audio>? audio;
  List<Video> video;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    audio: json["audio"] == null ? null : List<Audio>.from(json["audio"].map((x) => Audio.fromJson(x))),
    video: List<Video>.from(json["video"].map((x) => Video.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "audio": audio == null ? null : List<dynamic>.from(audio!.map((x) => x.toJson())),
    "video": List<dynamic>.from(video.map((x) => x.toJson())),
  };
}

class Audio {
  Audio({
    required this.title,
    required this.url,
  });

  String title;
  String url;

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
    title: json["title"],
    url: json["URL"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "URL": url,
  };
}

class Video {
  Video({
    required this.heading,
    required this.list,
  });

  String heading;
  List<ListElement> list;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    heading: json["heading"],
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "heading": heading,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class ListElement {
  ListElement({
    required this.youtubevid,
    required this.title,
  });

  String youtubevid;
  String title;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    youtubevid: json["youtubevid"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "youtubevid": youtubevid,
    "title": title,
  };
}

class Language {
  Language({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}*/
