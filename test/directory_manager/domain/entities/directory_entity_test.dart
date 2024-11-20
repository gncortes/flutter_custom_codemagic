import 'package:flutter_test/flutter_test.dart';
import 'package:custom_cicd/directory_manager/domain/entities/directory_entity.dart';

void main() {
  group('DirectoryEntity', () {
    test('Should create a DirectoryEntity with valid data', () {
      final entity = DirectoryEntity(
        id: 1,
        path: '/home/user/project',
        createdAt: DateTime(2023, 1, 1, 10, 0, 0),
        updatedAt: DateTime(2023, 1, 2, 12, 0, 0),
      );

      expect(entity.id, 1, reason: 'The id should be 1');
      expect(entity.path, '/home/user/project',
          reason: 'The path is incorrect');
      expect(entity.createdAt, DateTime(2023, 1, 1, 10, 0, 0),
          reason: 'The createdAt value is incorrect');
      expect(entity.updatedAt, DateTime(2023, 1, 2, 12, 0, 0),
          reason: 'The updatedAt value is incorrect');
    });

    test('Should throw an AssertionError if path is empty', () {
      expect(
        () => DirectoryEntity(
          id: 1,
          path: '',
          createdAt: DateTime(2023, 1, 1, 10, 0, 0),
          updatedAt: DateTime(2023, 1, 2, 12, 0, 0),
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
