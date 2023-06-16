import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();

  factory DatabaseService() => _databaseService;

  DatabaseService._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'flutter_sqflite_database.db');

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<Database> create() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'flutter_sqflite_database.db');
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE student(name TEXT, email TEXT,password Text)',
    );
  }

  Future<void> insertUser(user) async {
    final db = await _databaseService.database;

    await db?.insert(
      'student',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> users() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db!.query('student');
    return maps ?? [];
  }
}
