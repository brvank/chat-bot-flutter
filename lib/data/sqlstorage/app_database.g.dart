// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
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

  ChatDataDao? _chatDataDaoInstance;

  ChatMetaDataDao? _chatMetaDataDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
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
            'CREATE TABLE IF NOT EXISTS `ChatData` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `data` TEXT NOT NULL, `metaDataId` INTEGER NOT NULL, `owner` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ChatMetaData` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ChatDataDao get chatDataDao {
    return _chatDataDaoInstance ??= _$ChatDataDao(database, changeListener);
  }

  @override
  ChatMetaDataDao get chatMetaDataDao {
    return _chatMetaDataDaoInstance ??=
        _$ChatMetaDataDao(database, changeListener);
  }
}

class _$ChatDataDao extends ChatDataDao {
  _$ChatDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _chatDataInsertionAdapter = InsertionAdapter(
            database,
            'ChatData',
            (ChatData item) => <String, Object?>{
                  'id': item.id,
                  'data': item.data,
                  'metaDataId': item.metaDataId,
                  'owner': item.owner
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ChatData> _chatDataInsertionAdapter;

  @override
  Future<List<ChatData>> findAllChatData(int metaDataId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ChatData WHERE metaDataId = ?1',
        mapper: (Map<String, Object?> row) => ChatData(
            row['id'] as int?,
            row['data'] as String,
            row['metaDataId'] as int,
            row['owner'] as int),
        arguments: [metaDataId]);
  }

  @override
  Future<void> deleteChatData(int metaDataId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ChatData WHERE metaDataId = ?1',
        arguments: [metaDataId]);
  }

  @override
  Future<int> insertChatData(ChatData chatData) {
    return _chatDataInsertionAdapter.insertAndReturnId(
        chatData, OnConflictStrategy.abort);
  }
}

class _$ChatMetaDataDao extends ChatMetaDataDao {
  _$ChatMetaDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _chatMetaDataInsertionAdapter = InsertionAdapter(
            database,
            'ChatMetaData',
            (ChatMetaData item) =>
                <String, Object?>{'id': item.id, 'title': item.title}),
        _chatMetaDataUpdateAdapter = UpdateAdapter(
            database,
            'ChatMetaData',
            ['id'],
            (ChatMetaData item) =>
                <String, Object?>{'id': item.id, 'title': item.title}),
        _chatMetaDataDeletionAdapter = DeletionAdapter(
            database,
            'ChatMetaData',
            ['id'],
            (ChatMetaData item) =>
                <String, Object?>{'id': item.id, 'title': item.title});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ChatMetaData> _chatMetaDataInsertionAdapter;

  final UpdateAdapter<ChatMetaData> _chatMetaDataUpdateAdapter;

  final DeletionAdapter<ChatMetaData> _chatMetaDataDeletionAdapter;

  @override
  Future<List<ChatMetaData>> getAllChatMetaData() async {
    return _queryAdapter.queryList('SELECT * FROM ChatMetaData',
        mapper: (Map<String, Object?> row) =>
            ChatMetaData(row['id'] as int?, row['title'] as String));
  }

  @override
  Future<int> insertChatMetaData(ChatMetaData chatMetaData) {
    return _chatMetaDataInsertionAdapter.insertAndReturnId(
        chatMetaData, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateChatMetaData(ChatMetaData chatMetaData) {
    return _chatMetaDataUpdateAdapter.updateAndReturnChangedRows(
        chatMetaData, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteChatMetaData(ChatMetaData chatMetaData) async {
    await _chatMetaDataDeletionAdapter.delete(chatMetaData);
  }
}
