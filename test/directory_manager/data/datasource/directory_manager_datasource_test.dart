import 'package:custom_cicd/core/external/database/database_service.dart';
import 'package:custom_cicd/directory_manager/data/datasource/directory_manager_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:custom_cicd/directory_manager/data/models/directory_model.dart';

import '../../../mock/mocks.mocks.dart';

void main() {
  late DatabaseService mockDatabase;
  late DirectoryManagerDatasourceImpl datasource;

  setUp(() {
    mockDatabase = MockDatabaseService();
    datasource = DirectoryManagerDatasourceImpl(mockDatabase);
  });

  group('DirectoryManagerDatasourceImpl', () {
    test('Should return a list of DirectoryModel when query is successful',
        () async {
      // Dados simulados
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

      when(mockDatabase.query('directories')).thenAnswer((_) async => mockData);

      final result = await datasource.get();

      expect(result, isA<List<DirectoryModel>>());
      expect(result.length, 2);
      expect(result[0].path, '/home/user/project1');
      expect(result[1].path, '/home/user/project2');
    });

    test('Should throw an exception when database query fails', () async {
      when(mockDatabase.query('directories'))
          .thenThrow(Exception('Database error'));

      expect(
        () => datasource.get(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
