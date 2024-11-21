import 'package:custom_cicd/directory_manager/data/extensions/update_directory_adapter.dart';
import 'package:custom_cicd/directory_manager/domain/input/update_directory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddDirectoryInputAdapter', () {
    test('Should convert AddDirectoryInput to JSON correctly', () {
      final input = UpdateDirectoryInput(
        path: '/home/user/project',
        id: 1,
      );
      final json = input.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['path'], '/home/user/project');
    });

    test('Should throw an AssertionError if AddDirectoryInput is invalid', () {
      const invalidPath = '';

      expect(
        () => UpdateDirectoryInput(
          path: invalidPath,
          id: 1,
        ).toJson(),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
