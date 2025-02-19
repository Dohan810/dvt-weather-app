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
      version: 3, // Increment the version to trigger onUpgrade
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE settings (
            id INTEGER PRIMARY KEY,
            key TEXT,
            value TEXT
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
        if (oldVersion < 3) {
          await db.execute('''
            ALTER TABLE settings ADD COLUMN key TEXT
          ''');
          await db.execute('''
            ALTER TABLE settings ADD COLUMN value TEXT
          ''');
        }
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
    await db.insert(
      'settings',
      {'key': 'unit', 'value': unit},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    String? test = await getUnit();
    print('Saved unit: $unit, Retrieved unit: $test');
  }

  Future<String?> getUnit() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('settings', where: 'key = ?', whereArgs: ['unit']);
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  Future<void> insertOrUpdate(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<void> setCoinPageViewed() async {
    await insertOrUpdate('settings', {'key': 'coinPageViewed', 'value': 'true'});
  }

  Future<bool> isCoinPageViewed() async {
    final result = await query('settings', where: 'key = ?', whereArgs: ['coinPageViewed']);
    return result.isNotEmpty && result.first['value'] == 'true';
  }
}
