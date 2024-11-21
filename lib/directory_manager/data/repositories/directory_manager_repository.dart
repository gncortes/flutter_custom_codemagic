import 'package:custom_cicd/directory_manager/domain/input/add_directory.dart';

import '../extensions/directory_model_adapter.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/directory_entity.dart';
import '../../domain/failures/diretory_error.dart';
import '../../domain/repositories/directory_manager_repository.dart';
import '../datasource/directory_manager_datasource.dart';

class DirectoryManagerRepositoryImpl implements DirectoryManagerRepository {
  final DirectoryManagerDatasource datasource;

  const DirectoryManagerRepositoryImpl(this.datasource);

  @override
  Future<Either<DirectoryError, List<DirectoryEntity>>> getDirectories() async {
    try {
      final models = await datasource.get();

      final entities = models.map((model) => model.toEntity()).toList();

      return Right(entities);
    } on DirectoryError catch (e) {
      return Left(e);
    } on AssertionError catch (e) {
      return Left(
        DirectoryError(
          message: e.toString(),
          type: TypeOfDiretoryError.pathIsEmpty,
        ),
      );
    } catch (e) {
      return const Left(
        DirectoryError(
          message: 'Failed to fetch directories',
          type: TypeOfDiretoryError.unknown,
        ),
      );
    }
  }

  @override
  Future<Either<DirectoryError, DirectoryEntity>> add(
    AddDirectoryInput input,
  ) async {
    // TODO: implement add
    throw UnimplementedError();
  }
}
