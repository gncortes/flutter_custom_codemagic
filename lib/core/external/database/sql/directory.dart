class SQLDirectoryQueries {
  static const createTableDirectories = '''
    CREATE TABLE directories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT NOT NULL UNIQUE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
  ''';

  static const createTriggerUpdateAt = '''
  CREATE TRIGGER update_updated_at
    BEFORE UPDATE ON directories
    FOR EACH ROW
    WHEN OLD.path != NEW.path
    BEGIN
      UPDATE directories
      SET updated_at = CURRENT_TIMESTAMP
      WHERE id = OLD.id;
    END;
  ''';
}
