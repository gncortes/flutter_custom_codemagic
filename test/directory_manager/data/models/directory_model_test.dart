import 'package:custom_cicd/directory_manager/data/models/directory_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DirectoryModel', () {
    test('Should create a DirectoryModel from JSON', () {
      final json = {
        'id': 1,
        'path': '/home/user/project',
        'created_at': '2023-01-01T10:00:00',
        'updated_at': '2023-01-02T12:00:00',
      };

      final model = DirectoryModel.fromJson(json);

      expect(model.id, 1);
      expect(model.path, '/home/user/project');
      expect(model.createdAt, '2023-01-01T10:00:00');
      expect(model.updatedAt, '2023-01-02T12:00:00');
    });

    test('Should throw an error when JSON is missing required fields', () {
      final json = {
        'id': 1,
        'path': '/home/user/project',
        // Missing 'created_at' and 'updated_at'
      };

      expect(
        () => DirectoryModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('Should correctly handle extra fields in JSON', () {
      final json = {
        'id': 1,
        'path': '/home/user/project',
        'created_at': '2023-01-01T10:00:00',
        'updated_at': '2023-01-02T12:00:00',
        'extra_field': 'extra_value', // Extra field
      };

      final model = DirectoryModel.fromJson(json);

      expect(model.id, 1);
      expect(model.path, '/home/user/project');
      expect(model.createdAt, '2023-01-01T10:00:00');
      expect(model.updatedAt, '2023-01-02T12:00:00');
    });
  });
}
