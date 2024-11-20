abstract interface class DatabaseService {
  Future<void> init();

  Future<int> insert(
    String table,
    Map<String, dynamic> data,
  );

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  });

  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  });

  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  });

  Future<void> close();
}
