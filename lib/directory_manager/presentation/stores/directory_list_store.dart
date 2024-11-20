import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/directory_entity.dart';
import '../../domain/failures/diretory_error.dart';
import '../states/directory_list_state.dart';

class DirectoryListStore extends ValueNotifier<DirectoryListState> {
  DirectoryListStore() : super(DirectoryListLoadingState());

  Future<void> fetchDirectories(
    Future<Either<DirectoryError, List<DirectoryEntity>>> Function()
        fetchFunction,
  ) async {
    value = DirectoryListLoadingState();
    final directories = await fetchFunction();

    directories.fold((err) {
      value = DirectoryListErrorState(err);
    }, (data) {
      value = DirectoryListSucessState(data);
    });
  }
}
