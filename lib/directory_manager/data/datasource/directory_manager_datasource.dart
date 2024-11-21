import '../../../core/domain/failures/database_error.dart';
import '../../../core/external/database/database_service.dart';
import '../../domain/failures/diretory_error.dart';
import '../models/directory_model.dart';

abstract interface class DirectoryManagerDatasource {
  Future<List<DirectoryModel>> get();

  Future<DirectoryModel> add(Map<String, dynamic> data);
}

class DirectoryManagerDatasourceImpl implements DirectoryManagerDatasource {
  final DatabaseService _database;

  const DirectoryManagerDatasourceImpl(this._database);

  final String _table = 'directories';

  @override
  Future<List<DirectoryModel>> get() async {
    try {
      final response = await _database.query(_table);

      return response.map((map) => DirectoryModel.fromJson(map)).toList();
    } on DatabaseError catch (e) {
      final error = switch (e.errorType) {
        DatabaseErrorType.connectionError => DirectoryError(
            message: e.toString(),
            type: TypeOfDiretoryError.databaseError,
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

  @override
  Future<DirectoryModel> add(Map<String, dynamic> data) async {
    try {
      final id = await _database.insert(_table, data);

      final response = await _database.query(
        _table,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (response.isEmpty) {
        throw (const DirectoryError(
          message: 'Not found',
          type: TypeOfDiretoryError.notFound,
        ));
      }

      return DirectoryModel.fromJson(response.first);
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
    } on DirectoryError {
      rethrow;
    } catch (e) {
      throw DirectoryError(
        message: e.toString(),
        type: TypeOfDiretoryError.unknown,
      );
    }
  }
}
