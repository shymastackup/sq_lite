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
    String path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL
      )
    ''');
  }

  // Create
  Future<int> addContact(String name, String phone) async {
    final db = await database;
    return await db.insert('contacts', {'name': name, 'phone': phone});
  }

  // Read
  Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await database;
    return await db.query('contacts');
  }

  // Update
  Future<int> updateContact(int id, String name, String phone) async {
    final db = await database;
    return await db.update(
      'contacts',
      {'name': name, 'phone': phone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete
  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
