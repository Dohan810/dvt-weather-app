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
      version: 2, // Increment the version to trigger onUpgrade
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE settings (
            id INTEGER PRIMARY KEY,
            unit TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE locations (
            id INTEGER PRIMARY KEY,
            display_name TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS locations (
              id INTEGER PRIMARY KEY,
              display_name TEXT
            )
          ''');
        }
      },
    );
  }

  Future<void> saveUnit(String unit) async {
    final db = await database;
    await db.delete('settings'); // Clear previous settings
    await db.insert(
      'settings',
      {'unit': unit},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    String? test = await getUnit();
    print('Saved unit: $unit, Retrieved unit: $test');
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
