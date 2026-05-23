import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Flutter'ın yerel veritabanı kütüphanesi

// Bu kod, SQLite veritabanını başlatır, veri ekler ve sorgular.
class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'kits.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kits (
            id TEXT PRIMARY KEY,
            name TEXT,
            items TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertKit(String id, String name, List<String> items) async {
    final db = await database;
    await db.insert(
      'kits',
      {
        'id': id,
        'name': name,
        'items': items.join(','),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getAllKits() async {
    final db = await database;
    return await db.query('kits');
  }

  // ⚙️ Eksik silme metodu:
  static Future<void> deleteKit(String id) async {
    final db = await database;
    await db.delete(
      'kits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
