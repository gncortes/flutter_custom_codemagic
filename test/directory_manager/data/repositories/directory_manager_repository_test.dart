import 'package:custom_cicd/directory_manager/data/datasource/directory_manager_datasource.dart';
import 'package:custom_cicd/directory_manager/data/repositories/directory_manager_repository.dart';
import 'package:custom_cicd/directory_manager/domain/failures/diretory_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:custom_cicd/directory_manager/domain/entities/directory_entity.dart';
import 'package:custom_cicd/directory_manager/data/models/directory_model.dart';

import '../../../mock/mocks.mocks.dart';

void main() {
  late DirectoryManagerDatasource mockDatasource;
  late DirectoryManagerRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockDirectoryManagerDatasource();
    repository = DirectoryManagerRepositoryImpl(mockDatasource);
  });

  group('DirectoryManagerRepositoryImpl', () {
    test(
        'Should return a list of DirectoryEntity on successful datasource call',
        () async {
      final mockModels = [
        DirectoryModel.fromJson({
          'id': 1,
          'path': '/home/user/project1',
          'created_at': '2023-01-01T10:00:00',
          'updated_at': '2023-01-02T12:00:00',
        }),
        DirectoryModel.fromJson({
          'id': 3,
          'path': '/home/user/project2',
          'created_at': '2023-01-01T10:00:00',
          'updated_at': '2023-01-02T12:00:00',
        }),
      ];

      when(mockDatasource.get()).thenAnswer((_) async => mockModels);

      final result = await repository.getDirectories();

      expect(result.isRight(), true);

      result.fold(
        (error) => fail('Should not return an error'),
        (entities) {
          expect(entities, isA<List<DirectoryEntity>>());
          expect(entities.length, 2);
          expect(entities[0].path, '/home/user/project1');
        },
      );
    });

    test('Should return DirectoryError when model throws an [AssertException]',
        () async {
      final mockModels = [
        DirectoryModel.fromJson({
          'id': 1,
          'path': '',
          'created_at': '2023-01-01T10:00:00',
          'updated_at': '2023-01-02T12:00:00',
        }),
        DirectoryModel.fromJson({
          'id': 3,
          'path': '/home/user/project2',
          'created_at': '2023-01-01T10:00:00',
          'updated_at': '2023-01-02T12:00:00',
        }),
      ];

      when(mockDatasource.get()).thenAnswer((_) async => mockModels);

      final result = await repository.getDirectories();

      expect(result.isLeft(), true);

      result.fold(
        (error) {
          expect(error, isA<DirectoryError>());
          expect(error.type, TypeOfDiretoryError.pathIsEmpty);
        },
        (_) {
          fail('Should not return an content');
        },
      );
    });

    test('Should return DirectoryError when datasource throws an exception',
        () async {
      when(mockDatasource.get()).thenThrow(const DirectoryError(
        message: 'Database error',
        type: TypeOfDiretoryError.databaseError,
      ));

      final result = await repository.getDirectories();

      expect(result.isLeft(), true);

      result.fold(
        (error) {
          expect(error, isA<DirectoryError>());
          expect(error.type, TypeOfDiretoryError.databaseError);
        },
        (_) => fail('Should return an error'),
      );
    });

    test('Should return unknown error for generic exceptions', () async {
      when(mockDatasource.get()).thenThrow(Exception('Generic error'));

      final result = await repository.getDirectories();

      expect(result.isLeft(), true);

      result.fold(
        (error) {
          expect(error, isA<DirectoryError>());
          expect(error.type, TypeOfDiretoryError.unknown);
        },
        (_) => fail('Should return an error'),
      );
    });
  });
}
