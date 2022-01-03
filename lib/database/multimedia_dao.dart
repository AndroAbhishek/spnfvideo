import 'package:SPNF/model/Model_Multimedia.dart';
import 'package:SPNF/model/Multimedia.dart';

import 'package:floor/floor.dart';

@dao
abstract class multimedia_dao{

  @Query('SELECT * FROM $MULTIMEDIA_STRING_TABLE_NAME')
  Future<List<Model_Multimedia>?> fetchAllStoredData();

  @insert
  Future<void> insertMultimedia(Model_Multimedia multimedia);



  /*@Query('SELECT * FROM $LANGUAGES_TABLE_NAME')
  Future<List<Languages>?> fetchAllLanguages();

  @insert
  Future<void> insertLanguage(Languages languages);

  @Query('SELECT * FROM $DATA_TABLE_NAME')
  Future<List<Data>?> fetchAllData();

  @insert
  Future<void> insertData(Data data);*/





}