import 'package:custom_cicd/directory_manager/domain/input/add_directory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddDirectoryInput', () {
    test('Should create AddDirectoryInput with valid path', () {
      const validPath = '/home/user/project';

      final input = AddDirectoryInput(validPath);

      expect(input.path, validPath);
    });

    test('Should throw an AssertionError if path is empty', () {
      const invalidPath = '';

      expect(
        () => AddDirectoryInput(invalidPath),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
