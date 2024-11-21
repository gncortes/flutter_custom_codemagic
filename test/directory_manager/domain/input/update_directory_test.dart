import 'package:custom_cicd/directory_manager/domain/input/update_directory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UpdateDirectoryInput', () {
    test('Should create UpdateDirectoryInput with valid id and path', () {
      const validId = 1;
      const validPath = '/home/user/project';

      final input = UpdateDirectoryInput(id: validId, path: validPath);

      expect(input.id, validId);
      expect(input.path, validPath);
    });

    test('Should throw AssertionError if path is empty', () {
      const validId = 1;
      const invalidPath = '';

      expect(
        () => UpdateDirectoryInput(id: validId, path: invalidPath),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Should throw AssertionError if id is negative', () {
      const invalidId = -1;
      const validPath = '/home/user/project';

      expect(
        () => UpdateDirectoryInput(id: invalidId, path: validPath),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Should throw AssertionError with correct message when path is empty',
        () {
      const validId = 1;
      const invalidPath = '';

      expect(
        () => UpdateDirectoryInput(id: validId, path: invalidPath),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Should throw AssertionError with correct message when id is negative',
        () {
      const invalidId = -1;
      const validPath = '/home/user/project';

      expect(
        () => UpdateDirectoryInput(id: invalidId, path: validPath),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
