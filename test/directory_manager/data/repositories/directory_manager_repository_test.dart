import 'package:custom_cicd/directory_manager/data/datasource/directory_manager_datasource.dart';
import 'package:custom_cicd/directory_manager/data/extensions/add_directory_adapter.dart';
import 'package:custom_cicd/directory_manager/data/repositories/directory_manager_repository.dart';
import 'package:custom_cicd/directory_manager/domain/failures/diretory_error.dart';
import 'package:custom_cicd/directory_manager/domain/input/add_directory.dart';
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

  group('DirectoryManagerRepositoryImpl - get', () {
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

  group('DirectoryManagerRepositoryImpl - add', () {
    test('Should return DirectoryEntity when datasource add is successful',
        () async {
      final input = AddDirectoryInput('/home/user/project1');
      final mockModel = DirectoryModel.fromJson({
        'id': 1,
        'path': '/home/user/project1',
        'created_at': '2023-01-01T10:00:00',
        'updated_at': '2023-01-02T12:00:00',
      });

      when(mockDatasource.add(input.toJson()))
          .thenAnswer((_) async => mockModel);

      final result = await repository.add(input);

      expect(result.isRight(), true);

      result.fold(
        (error) => fail('Should not return an error'),
        (entity) {
          expect(entity, isA<DirectoryEntity>());
          expect(entity.id, 1);
          expect(entity.path, '/home/user/project1');
        },
      );
    });

    test('Should return DirectoryError when datasource throws an error',
        () async {
      final input = AddDirectoryInput('/home/user/project1');
      const mockError = DirectoryError(
        message: 'Database error',
        type: TypeOfDiretoryError.databaseError,
      );

      when(mockDatasource.add(input.toJson())).thenThrow(mockError);

      final result = await repository.add(input);

      expect(result.isLeft(), true);

      result.fold(
        (error) {
          expect(error, isA<DirectoryError>());
          expect(error.type, TypeOfDiretoryError.databaseError);
        },
        (_) => fail('Should return an error'),
      );
    });

    test(
        'Should return DirectoryError with unknown type for generic exceptions',
        () async {
      final input = AddDirectoryInput('/home/user/project1');

      when(mockDatasource.add(input.toJson()))
          .thenThrow(Exception('Generic error'));

      final result = await repository.add(input);

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
