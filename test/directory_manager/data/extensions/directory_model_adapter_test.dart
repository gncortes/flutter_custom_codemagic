import 'package:custom_cicd/directory_manager/data/extensions/directory_model_adapter.dart';
import 'package:custom_cicd/directory_manager/data/models/directory_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DirectoryModelAdapter', () {
    test('Should convert DirectoryModel to DirectoryEntity correctly', () {
      final json = {
        'id': 1,
        'path': '/home/user/project',
        'created_at': '2023-01-01T10:00:00',
        'updated_at': '2023-01-02T12:00:00',
      };

      final model = DirectoryModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, 1);
      expect(entity.path, '/home/user/project');
      expect(entity.createdAt, DateTime(2023, 1, 1, 10, 0, 0).toLocal());
      expect(entity.updatedAt, DateTime(2023, 1, 2, 12, 0, 0).toLocal());
    });

    test('Should throw an error if createdAt or updatedAt is not parseable',
        () {
      final json = {
        'id': 1,
        'path': '/home/user/project',
        'created_at': 'invalid-date',
        'updated_at': '2023-01-02T12:00:00',
      };

      final model = DirectoryModel.fromJson(json);

      expect(
        () => model.toEntity(),
        throwsA(isA<FormatException>()),
      );
    });

    test('Should throw an error if path is empty', () {
      final json = {
        'id': 1,
        'path': '',
        'created_at': '2023-01-01T10:00:00',
        'updated_at': '2023-01-02T12:00:00',
      };

      final model = DirectoryModel.fromJson(json);

      expect(
        () => model.toEntity(),
        throwsA(isA<AssertionError>()), // Se a validação for via assert
      );
    });
  });
}
