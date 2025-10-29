import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/species.dart';

class DatabaseHelper {
  static const _dbName = 'species_catalog.db';
  static const _dbVersion = 2;
  static const table = 'species';

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;
  Future<Database> get database async => _database ??= await _init();

  Future<Database> _init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        imagePath TEXT,
        domain TEXT,
        kingdom TEXT,
        phylum TEXT,
        className TEXT,
        orderName TEXT,
        family TEXT,
        genus TEXT,
        species TEXT
        
      )
    ''');
  }

  // CRUD
  Future<int> insert(Species s) async {
    final db = await database;
    return db.insert(table, s.toMap());
  }

  Future<List<Species>> getAll() async {
    final db = await database;
    final rows = await db.query(table, orderBy: 'id DESC');
    return rows.map((e) => Species.fromMap(e)).toList();
  }

  Future<int> update(Species s) async {
    final db = await database;
    return db.update(table, s.toMap(), where: 'id = ?', whereArgs: [s.id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // Category helper
  Future<List<String>> distinct(String column) async {
    final db = await database;
    final rows = await db.rawQuery('SELECT DISTINCT $column FROM $table');
    return rows
        .map((e) => (e[column] as String?)?.trim() ?? '')
        .where((v) => v.isNotEmpty)
        .toList();
  }

  Future<List<Species>> whereEquals(String column, String value) async {
    final db = await database;
    final rows = await db.query(
      table,
      where: '$column = ?',
      whereArgs: [value],
    );
    return rows.map((e) => Species.fromMap(e)).toList();
  }
}
