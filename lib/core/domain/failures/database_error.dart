import 'app_error.dart';

class DatabaseError extends AppError {
  final DatabaseErrorType errorType;

  DatabaseError(this.errorType, String message) : super(message);
}

enum DatabaseErrorType {
  connectionError,
  insertError,
  updateError,
  deleteError,
  queryError,
}
