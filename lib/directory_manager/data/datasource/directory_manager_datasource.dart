import '../../../core/domain/failures/database_error.dart';
import '../../../core/external/database/database_service.dart';
import '../../domain/failures/diretory_error.dart';
import '../models/directory_model.dart';

abstract interface class DirectoryManagerDatasource {
  Future<List<DirectoryModel>> get();
}

class DirectoryManagerDatasourceImpl implements DirectoryManagerDatasource {
  final DatabaseService _database;

  const DirectoryManagerDatasourceImpl(this._database);

  @override
  Future<List<DirectoryModel>> get() async {
    try {
      final response = await _database.query('directories');

      return response.map((map) => DirectoryModel.fromJson(map)).toList();
    } on DatabaseError catch (e) {
      final error = switch (e.errorType) {
        DatabaseErrorType.connectionError => DirectoryError(
            message: e.toString(),
            type: TypeOfDiretoryError.databaseError,
          ),
        DatabaseErrorType.insertError => DirectoryError(
            message: e.toString(),
            type: TypeOfDiretoryError.pathAlredyExists,
          ),
        _ => DirectoryError(
            message: e.toString(),
            type: TypeOfDiretoryError.unknown,
          )
      };

      throw (error);
    } catch (e) {
      throw DirectoryError(
        message: e.toString(),
        type: TypeOfDiretoryError.unknown,
      );
    }
  }
}
