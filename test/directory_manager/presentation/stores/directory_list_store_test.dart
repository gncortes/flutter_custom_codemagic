import 'package:custom_cicd/directory_manager/domain/domain.dart';
import 'package:custom_cicd/directory_manager/presentation/states/directory_list_state.dart';
import 'package:custom_cicd/directory_manager/presentation/stores/directory_list_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  late DirectoryListStore store;

  setUp(() {
    store = DirectoryListStore();
  });

  group('DirectoryListStore', () {
    test(
        'Should emit DirectoryListLoadingState and then DirectoryListSucessState',
        () async {
      final mockData = [
        DirectoryEntity(
          id: 1,
          path: '/home/user/project1',
          createdAt: DateTime(2023, 1, 1, 10, 0, 0),
          updatedAt: DateTime(2023, 1, 2, 12, 0, 0),
        ),
        DirectoryEntity(
          id: 2,
          path: '/home/user/project2',
          createdAt: DateTime(2023, 2, 1, 10, 0, 0),
          updatedAt: DateTime(2023, 2, 2, 12, 0, 0),
        ),
      ];

      Future<Either<DirectoryError, List<DirectoryEntity>>>
          fetchFunction() async {
        return Right(mockData);
      }

      await store.fetchDirectories(fetchFunction);

      expect(store.value, isA<DirectoryListSucessState>());
      final successState = store.value as DirectoryListSucessState;
      expect(successState.list, mockData);
    });

    test(
        'Should emit DirectoryListLoadingState and then DirectoryListErrorState',
        () async {
      const mockError = DirectoryError(
        message: 'Failed to fetch directories',
        type: TypeOfDiretoryError.databaseError,
      );

      Future<Either<DirectoryError, List<DirectoryEntity>>>
          fetchFunction() async {
        return const Left(mockError);
      }

      await store.fetchDirectories(fetchFunction);

      expect(store.value, isA<DirectoryListErrorState>());
      final errorState = store.value as DirectoryListErrorState;
      expect(errorState.error, mockError);
    });
  });
}
