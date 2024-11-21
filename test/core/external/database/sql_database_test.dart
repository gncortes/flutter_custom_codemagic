import 'package:custom_cicd/core/domain/failures/database_error.dart';
import 'package:custom_cicd/core/external/database/sql_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    // Initialize FFI support for unit tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SQLiteDatabase - Directories', () {
    late SQLiteDatabase database;

    setUp(() async {
      database = SQLiteDatabase();
      await database.init();
      await database.delete('directories');
    });

    tearDown(() async {
      await database.close();
    });

    test('Should directories table be empty', () async {
      final result = await database.query('directories');
      expect(result.length, isZero);
    });

    test('Should insert a record into the directories table', () async {
      final data = {'path': '/home/user/project'};
      final id = await database.insert('directories', data);

      expect(id, isNonZero);

      final result = await database.query('directories');
      expect(result.length, 1);
      expect(result[0]['path'], '/home/user/project');
    });

    test('Should query records from the directories table', () async {
      final data1 = {'path': '/home/user/project1'};
      final data2 = {'path': '/home/user/project2'};

      await database.insert('directories', data1);
      await database.insert('directories', data2);

      final result = await database.query(
        'directories',
        where: 'path = ?',
        whereArgs: ['/home/user/project1'],
      );
      expect(result.length, 1);
      expect(result[0]['path'], '/home/user/project1');
    });

    test(
        'Should update a record in the directories table and update updated_at',
        () async {
      final data = {'path': '/home/user/old_project'};
      final id = await database.insert('directories', data);

      final resultCreate = await database.query(
        'directories',
        where: 'id = ?',
        whereArgs: [id],
      );

      final updatedAtCreate = resultCreate[0]['updated_at'];

      expect(updatedAtCreate, isNotNull);

      await Future.delayed(const Duration(seconds: 2));

      final updatedRows = await database.update(
        'directories',
        {'path': '/home/user/new_project'},
        where: 'id = ?',
        whereArgs: [id],
      );

      expect(updatedRows, 1);

      final resultUpdate = await database.query(
        'directories',
        where: 'id = ?',
        whereArgs: [id],
      );

      final updatedAtUpdate = resultUpdate[0]['updated_at'];

      expect(resultUpdate[0]['path'], '/home/user/new_project');
      expect(updatedAtUpdate, isNotNull);

      expect(
        updatedAtUpdate == updatedAtCreate,
        isFalse,
      );
    });

    test('Should delete a record from the directories table', () async {
      final data = {'path': '/home/user/project_to_delete'};
      final id = await database.insert('directories', data);

      final deletedRows = await database.delete(
        'directories',
        where: 'id = ?',
        whereArgs: [id],
      );
      expect(deletedRows, 1);

      final result = await database.query('directories');
      expect(result.isEmpty, true);
    });

    test('Should not insert duplicate paths into the directories table',
        () async {
      final data = {'path': '/home/user/unique_project'};

      final initialQueryResponse = await database.query('directories');
      expect(initialQueryResponse.length, isZero);

      final firstInsertId = await database.insert('directories', data);
      expect(firstInsertId, isNonZero);

      expect(
        () => database.insert('directories', data),
        throwsA(predicate<DatabaseError>(
          (e) => e.errorType == DatabaseErrorType.insertError,
        )),
      );

      final finalQueryResponse = await database.query('directories');
      expect(finalQueryResponse.length, 1);
      expect(finalQueryResponse[0]['path'], '/home/user/unique_project');
    });
  });
}
