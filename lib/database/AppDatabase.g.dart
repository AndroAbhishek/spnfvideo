// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  multimedia_dao? _multimediaDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `multimedia_string` (`json_id` INTEGER, `jsonData` TEXT, PRIMARY KEY (`json_id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  multimedia_dao get multimediaDao {
    return _multimediaDaoInstance ??=
        _$multimedia_dao(database, changeListener);
  }
}

class _$multimedia_dao extends multimedia_dao {
  _$multimedia_dao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _model_MultimediaInsertionAdapter = InsertionAdapter(
            database,
            'multimedia_string',
            (Model_Multimedia item) => <String, Object?>{
                  'json_id': item.json_id,
                  'jsonData': item.jsonData
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Model_Multimedia> _model_MultimediaInsertionAdapter;

  @override
  Future<List<Model_Multimedia>?> fetchAllStoredData() async {
    return _queryAdapter.queryList('SELECT * FROM multimedia_string',
        mapper: (Map<String, Object?> row) => Model_Multimedia(
            json_id: row['json_id'] as int?,
            jsonData: row['jsonData'] as String?));
  }

  @override
  Future<void> insertMultimedia(Model_Multimedia multimedia) async {
    await _model_MultimediaInsertionAdapter.insert(
        multimedia, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _multimediaConvertor = MultimediaConvertor();
final _dataConvertor = DataConvertor();
final _languageConvertor = LanguageConvertor();
final _audioConvertor = AudioConvertor();
final _videoConvertor = VideoConvertor();
final _listVideoConvertor = ListVideoConvertor();
