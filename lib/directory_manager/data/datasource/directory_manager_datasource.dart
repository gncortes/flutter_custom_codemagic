import '../../../core/external/database/database_service.dart';
import '../models/directory_model.dart';

abstract interface class DirectoryManagerDatasource {
  Future<List<DirectoryModel>> get();
}

class DirectoryManagerDatasourceImpl implements DirectoryManagerDatasource {
  final DatabaseService _database;

  const DirectoryManagerDatasourceImpl(this._database);

  @override
  Future<List<DirectoryModel>> get() async {
    final response = await _database.query('directories');

    return response.map((map) => DirectoryModel.fromJson(map)).toList();
  }
}
