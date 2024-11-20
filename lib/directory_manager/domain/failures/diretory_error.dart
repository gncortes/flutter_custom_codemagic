import '../../../core/domain/failures/app_error.dart';

enum TypeOfDiretoryError {
  databaseError,
  pathIsEmpty,
  notFound,
  unknown,
}

class DirectoryError extends AppError {
  final TypeOfDiretoryError type;

  const DirectoryError({
    required String message,
    required this.type,
  }) : super(message);
}
