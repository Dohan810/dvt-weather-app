import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'weather_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY,
        unit TEXT
      )
    ''');
  }

  Future<void> saveUnit(String unit) async {
    final db = await database;
    await db.insert(
      'settings',
      {'unit': unit},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getUnit() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('settings');
    if (maps.isNotEmpty) {
      return maps.first['unit'] as String?;
    }
    return null;
  }
}
