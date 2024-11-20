import '../../domain/entities/directory_entity.dart';
import '../../domain/failures/diretory_error.dart';

sealed class DirectoryListState {}

class DirectoryListLoadingState implements DirectoryListState {}

class DirectoryListErrorState implements DirectoryListState {
  final DirectoryError error;

  const DirectoryListErrorState(this.error);
}

class DirectoryListSucessState implements DirectoryListState {
  final List<DirectoryEntity> list;

  const DirectoryListSucessState(this.list);
}
