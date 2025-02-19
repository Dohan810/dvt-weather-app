// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weather_wise/shared/utils/k_print.dart';
import 'package:weather_wise/shared/utils/permissions_utils.dart';

class LocationApi {
  static const String _baseUrl =
      'https://nominatim.openstreetmap.org/search.php';

  Future<List<Map<String, dynamic>>> getLocationSuggestions(
      String query) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(
          Uri.parse('$_baseUrl?q=$query&polygon_geojson=1&format=jsonv2'));
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> json = jsonDecode(responseBody);
        return json.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load location suggestions');
      }
    } catch (e) {
      KPrint.debug('Error fetching location suggestions: $e');
      return [];
    } finally {
      client.close();
    }
  }

  Future<void> saveLocation(String displayName) async {
    final db = await _initDatabase();
    await db.insert(
      'locations',
      {'display_name': displayName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSavedLocations() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('locations');
    return maps;
  }

  Future<void> deleteLocation(int id) async {
    final db = await _initDatabase();
    await db.delete('locations', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, double>> getLatLonFromDisplayName(
      String displayName) async {
    if (displayName == "Current Location") {
      Position? l = await PermissionsUtils.getCurrentLocation();
      return {
        'lat': l!.latitude,
        'lon': l.longitude,
      };
    }

    final suggestions = await getLocationSuggestions(displayName);
    if (suggestions.isNotEmpty) {
      final suggestion = suggestions.first;
      return {
        'lat': double.parse(suggestion['lat']),
        'lon': double.parse(suggestion['lon']),
      };
    } else {
      throw Exception('Location not found');
    }
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
}
