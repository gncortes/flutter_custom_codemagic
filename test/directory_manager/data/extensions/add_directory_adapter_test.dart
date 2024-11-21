import 'package:custom_cicd/directory_manager/data/extensions/add_directory_adapter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_cicd/directory_manager/domain/input/add_directory.dart';

void main() {
  group('AddDirectoryInputAdapter', () {
    test('Should convert AddDirectoryInput to JSON correctly', () {
      final input = AddDirectoryInput('/home/user/project');
      final json = input.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['path'], '/home/user/project');
    });

    test('Should throw an AssertionError if AddDirectoryInput is invalid', () {
      const invalidPath = '';

      expect(
        () => AddDirectoryInput(invalidPath).toJson(),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
