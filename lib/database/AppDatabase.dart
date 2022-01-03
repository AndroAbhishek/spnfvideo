import 'dart:async';

import 'package:SPNF/database/multimedia_dao.dart';
import 'package:SPNF/model/Datum.dart';
import 'package:SPNF/model/Languages.dart';
import 'package:SPNF/model/Model_Multimedia.dart';
import 'package:SPNF/model/Audio_Model.dart';
import 'package:SPNF/model/List_Video.dart';
import 'package:SPNF/model/Multimedia.dart';
import 'package:SPNF/model/Video_Model.dart';
import 'package:SPNF/typeconvertors/AudioConvertor.dart';

import 'package:SPNF/typeconvertors/ListVideoConvertor.dart';
import 'package:SPNF/typeconvertors/MultimediaConvertor.dart';
import 'package:SPNF/typeconvertors/VideoConvertor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:SPNF/typeconvertors/DataConvertor.dart';
import 'package:SPNF/typeconvertors/LanguageConvertor.dart';
import 'package:floor/floor.dart';


part 'AppDatabase.g.dart';



@TypeConverters([MultimediaConvertor,DataConvertor,LanguageConvertor,AudioConvertor,VideoConvertor,ListVideoConvertor])
@Database(version: 1, entities: [Model_Multimedia])
// @Database(version: 1, entities: [Multimedia,Audio_Model,Data,Languages,List_Video,Video_Model])
abstract class AppDatabase extends FloorDatabase{
  multimedia_dao get multimediaDao;
}