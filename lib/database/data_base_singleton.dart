/*
import 'multimedia_dao.dart';
import 'AppDatabase.dart';

class DatabaseSingleton {
  AppDatabase database ;

  instance._privateConstructor() {
    var db = $FloorAppDatabase
        .databaseBuilder('multimedia_Subhash.db')
        .build();
    db.then((value) {
      this.database = value;
    });
  }

  multimedia_dao getMultimediaDao() => database.multimediaDao;

  static final DatabaseSingleton instance =
      DatabaseSingleton._privateConstructor();

  factory DatabaseSingleton() {
    return instance;
  }
}*/
