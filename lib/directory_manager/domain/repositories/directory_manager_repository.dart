import 'package:dartz/dartz.dart';
import '../entities/directory_entity.dart';
import '../failures/diretory_error.dart';
import '../input/add_directory.dart';

abstract interface class DirectoryManagerRepository {
  Future<Either<DirectoryError, List<DirectoryEntity>>> getDirectories();

  Future<Either<DirectoryError, DirectoryEntity>> add(AddDirectoryInput input);
}
