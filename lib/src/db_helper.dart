import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'memoria.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE scores(id INTEGER PRIMARY KEY, level INTEGER, time INTEGER)',
        );
      },
      version: 1,
    );
  }

  // Método para guardar el tiempo en la base de datos
  static Future<void> saveScore(int level, int time) async {
    final db = await getDatabase();
    await db.insert(
      'scores',
      {'level': level, 'time': time},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para obtener el mejor tiempo de un nivel específico
  static Future<int?> getBestScore(int level) async {
    final db = await getDatabase();
    final result = await db.query(
      'scores',
      where: 'level = ?',
      whereArgs: [level],
      orderBy: 'time ASC',
      limit: 1,
    );
    if (result.isNotEmpty) return result.first['time'] as int;
    return null;
  }
}
