import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/failures/database_error.dart';
import 'database_service.dart';
import 'sql/directory.dart';

class SQLiteDatabase implements DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      try {
        String path = join(await getDatabasesPath(), 'app_database.db');
        _database = await openDatabase(
          path,
          version: 1,
          onCreate: (db, version) async {
            await db.execute(SQLDirectoryQueries.createTableDirectories);
            await db.execute(SQLDirectoryQueries.createTriggerUpdateAt);
          },
        );
      } catch (e) {
        throw DatabaseError(
          DatabaseErrorType.connectionError,
          'Failed to connect to the database: ${e.toString()}',
        );
      }
    }
    return _database!;
  }

  @override
  Future<void> init() async {
    await database;
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      final id = await db.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      return id;
    } catch (e) {
      throw DatabaseError(
        DatabaseErrorType.insertError,
        'Failed to insert into table $table: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final db = await database;
      return await db.query(
        table,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      throw DatabaseError(
        DatabaseErrorType.queryError,
        'Failed to query table $table: ${e.toString()}',
      );
    }
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      final db = await database;
      return await db.update(
        table,
        data,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      throw DatabaseError(
        DatabaseErrorType.updateError,
        'Failed to update table $table: ${e.toString()}',
      );
    }
  }

  @override
  Future<int> delete(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    try {
      final db = await database;
      return await db.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      throw DatabaseError(DatabaseErrorType.deleteError,
          'Failed to delete from table $table: ${e.toString()}');
    }
  }

  @override
  Future<void> close() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
      }
    } catch (e) {
      throw DatabaseError(
        DatabaseErrorType.connectionError,
        'Failed to close the database: ${e.toString()}',
      );
    }
  }
}
