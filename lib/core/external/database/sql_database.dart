import 'package:flutter/foundation.dart';
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

        // Chamada para verificar e corrigir a tabela
        await _checkAndFixDirectoriesTable();
      } catch (e, stacktrace) {
        if (kDebugMode) {
          print('Error: $e');
          print('StackTrace: $stacktrace');
        }
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

  /// Verifica e corrige a tabela `directories` se necessário
  Future<void> _checkAndFixDirectoriesTable() async {
    try {
      final db = await database;

      // Verifica se há um índice UNIQUE na tabela directories
      final indexInfo = await db.rawQuery("PRAGMA index_list('directories')");
      final hasUniqueConstraint = indexInfo
          .any((index) => index['name'] != null && index['unique'] == 1);

      if (!hasUniqueConstraint) {
        // Renomeie a tabela antiga
        await db.execute("ALTER TABLE directories RENAME TO old_directories");

        // Crie a tabela corrigida com UNIQUE
        await db.execute(SQLDirectoryQueries.createTableDirectories);

        // Migre os dados da tabela antiga
        await db.execute('''
        INSERT OR IGNORE INTO directories (id, path, created_at, updated_at)
        SELECT id, path, created_at, updated_at FROM old_directories
      ''');

        // Exclua a tabela antiga
        await db.execute("DROP TABLE old_directories");

        if (kDebugMode) {
          print(
              "Table `directories` was fixed with UNIQUE constraint on `path`.");
        }
      }
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error fixing `directories` table: $e');
        print('StackTrace: $stacktrace');
      }
      throw DatabaseError(
        DatabaseErrorType.connectionError,
        'Failed to verify or fix `directories` table: ${e.toString()}',
      );
    }
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
      print(id);
      return id;
    } catch (e, stacktrace) {
      print('on stacktrace');
      if (kDebugMode) {
        print('Error: $e');
        print('StackTrace: $stacktrace');
      }
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
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error: $e');
        print('StackTrace: $stacktrace');
      }
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
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error: $e');
        print('StackTrace: $stacktrace');
      }
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
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error: $e');
        print('StackTrace: $stacktrace');
      }
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
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error: $e');
        print('StackTrace: $stacktrace');
      }
      throw DatabaseError(
        DatabaseErrorType.connectionError,
        'Failed to close the database: ${e.toString()}',
      );
    }
  }
}
