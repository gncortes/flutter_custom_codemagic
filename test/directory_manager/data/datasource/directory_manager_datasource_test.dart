import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:custom_cicd/core/external/database/database_service.dart';
import 'package:custom_cicd/directory_manager/data/datasource/directory_manager_datasource.dart';
import 'package:custom_cicd/directory_manager/data/models/directory_model.dart';
import 'package:custom_cicd/core/domain/failures/database_error.dart';
import 'package:custom_cicd/directory_manager/domain/failures/diretory_error.dart';

import '../../../mock/mocks.mocks.dart';

void main() {
  late DatabaseService mockDatabase;
  late DirectoryManagerDatasourceImpl datasource;
  late String directories;

  setUp(() {
    directories = 'directories';
    mockDatabase = MockDatabaseService();
    datasource = DirectoryManagerDatasourceImpl(mockDatabase);
  });

  group('DirectoryManagerDatasourceImpl - get', () {
    test('Should return a list of DirectoryModel when query is successful',
        () async {
      final mockData = [
        {
          'id': 1,
          'path': '/home/user/project1',
          'created_at': '2023-01-01T10:00:00',
          'updated_at': '2023-01-02T12:00:00',
        },
        {
          'id': 2,
          'path': '/home/user/project2',
          'created_at': '2023-02-01T10:00:00',
          'updated_at': '2023-02-02T12:00:00',
        },
      ];

      when(mockDatabase.query(directories)).thenAnswer((_) async => mockData);

      final result = await datasource.get();

      expect(result, isA<List<DirectoryModel>>());
      expect(result.length, 2);
      expect(result[0].path, '/home/user/project1');
      expect(result[1].path, '/home/user/project2');
    });

    test('Should throw DirectoryError with databaseError when connection fails',
        () async {
      when(mockDatabase.query(directories)).thenThrow(
        DatabaseError(
          DatabaseErrorType.connectionError,
          'Connection failed',
        ),
      );

      expect(
        () => datasource.get(),
        throwsA(
          predicate<DirectoryError>(
            (e) => e.type == TypeOfDiretoryError.databaseError,
          ),
        ),
      );
    });

    test('Should throw DirectoryError with unknown type for generic errors',
        () async {
      when(mockDatabase.query(directories))
          .thenThrow(Exception('Unknown error'));

      expect(
        () => datasource.get(),
        throwsA(
          predicate<DirectoryError>(
              (e) => e.type == TypeOfDiretoryError.unknown),
        ),
      );
    });
  });

  group('DirectoryManagerDatasourceImpl - add', () {
    test('Should insert a directory and return DirectoryModel on success',
        () async {
      const directoryData = {'path': '/home/user/project1'};

      const insertedId = 1;
      final mockResponse = [
        {
          'id': insertedId,
          'path': '/home/user/project1',
          'created_at': '2023-01-01T10:00:00',
          'updated_at': '2023-01-01T10:00:00',
        },
      ];

      when(mockDatabase.insert(directories, directoryData))
          .thenAnswer((_) async => insertedId);
      when(mockDatabase.query(
        'directories',
        where: 'id = ?',
        whereArgs: [insertedId],
      )).thenAnswer((_) async => mockResponse);

      final result = await datasource.add(directoryData);

      expect(result, isA<DirectoryModel>());
      expect(result.id, insertedId);
      expect(result.path, '/home/user/project1');
    });

    test('Should throw DirectoryError when query returns empty', () async {
      const directoryData = {'path': '/home/user/project1'};

      const insertedId = 1;

      when(mockDatabase.insert(directories, directoryData))
          .thenAnswer((_) async => insertedId);
      when(mockDatabase.query(
        directories,
        where: 'id = ?',
        whereArgs: [insertedId],
      )).thenAnswer((_) async => []);

      expect(
        () => datasource.add(directoryData),
        throwsA(
          predicate<DirectoryError>(
            (e) {
              return e.type == TypeOfDiretoryError.notFound;
            },
          ),
        ),
      );
    });

    test('Should throw DirectoryError for database connection error', () async {
      const directoryData = {'path': '/home/user/project1'};

      when(mockDatabase.insert(directories, directoryData)).thenThrow(
        DatabaseError(
          DatabaseErrorType.connectionError,
          'Connection error',
        ),
      );

      expect(
        () => datasource.add(directoryData),
        throwsA(
          predicate<DirectoryError>(
            (e) => e.type == TypeOfDiretoryError.databaseError,
          ),
        ),
      );
    });

    test('Should throw DirectoryError for unknown database error', () async {
      const directoryData = {'path': '/home/user/project1'};

      when(mockDatabase.insert(directories, directoryData)).thenThrow(
        Exception('Unknown error'),
      );

      expect(
        () => datasource.add(directoryData),
        throwsA(
          predicate<DirectoryError>(
            (e) => e.type == TypeOfDiretoryError.unknown,
          ),
        ),
      );
    });
  });

  group('DirectoryManagerDatasourceImpl - update', () {});
}
