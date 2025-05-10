import 'package:sqflite/sqflite.dart';

class SqliteClient {
  Database? _database;
  final String databasePath;

  SqliteClient(this.databasePath);

  Future<void> open() async {
    _database = await openDatabase(databasePath);
  }

  Future<List<Map<String, dynamic>>> query(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    if (_database == null) {
      throw StateError('Database is not open.');
    }
    return await _database!.rawQuery(sql, arguments);
  }

  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    if (_database == null) {
      throw StateError('Database is not open.');
    }
    await _database!.rawExec(sql, arguments);
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
