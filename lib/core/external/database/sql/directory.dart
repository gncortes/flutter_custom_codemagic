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
    AFTER UPDATE ON directories
    BEGIN
      UPDATE directories
      SET updated_at = CURRENT_TIMESTAMP
      WHERE id = NEW.id;
    END;
  ''';
}
