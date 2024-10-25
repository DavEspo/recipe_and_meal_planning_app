import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Private constructor
  DatabaseHelper._internal();

  // Factory constructor
  factory DatabaseHelper() {
    return _instance;
  }

  static Database? _database;

  // Column names
  static const String columnFirstName = 'firstName';
  static const String columnLastName = 'lastName';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnFirstName TEXT,
            $columnLastName TEXT,
            $columnEmail TEXT UNIQUE,
            $columnPassword TEXT
          )
        ''');
      },
    );
  }

  // Insert a new user into the database
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  // Fetch a user by email and password
  Future<List<Map<String, dynamic>>> fetchUser(String email, String password) async {
    final db = await database;
    return await db.query(
      'users',
      where: '$columnEmail = ? AND $columnPassword = ?',
      whereArgs: [email, password],
    );
  }

  // Logout user by clearing user data
  Future<void> logoutUser() async {
    final db = await database;
    
    // Clear all users from the users table
    await db.delete('users'); // This removes all users
  }
}
