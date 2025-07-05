import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/guest_biodata.dart';
import '../models/guest_book.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'guest_book.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        created_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE guess_biodata (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        users_id INTEGER NOT NULL,
        full_name TEXT NOT NULL,
        address TEXT,
        phone_number TEXT,
        email TEXT,
        created_at INTEGER,
        FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE guess_books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        guess_id INTEGER NOT NULL,
        message TEXT NOT NULL,
        created_by INTEGER,
        created_at INTEGER,
        FOREIGN KEY (guess_id) REFERENCES guess_biodata(id) ON DELETE CASCADE,
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
      )
    ''');
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByUsernameAndPassword(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Guest Biodata operations
  Future<int> insertGuestBiodata(GuestBiodata guestBiodata) async {
    final db = await database;
    return await db.insert('guess_biodata', guestBiodata.toMap());
  }

  Future<List<GuestBiodata>> getAllGuestBiodata() async {
    final db = await database;
    final result = await db.query('guess_biodata', orderBy: 'created_at DESC');
    return result.map((map) => GuestBiodata.fromMap(map)).toList();
  }

  Future<GuestBiodata?> getGuestBiodataById(int id) async {
    final db = await database;
    final result = await db.query(
      'guess_biodata',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return GuestBiodata.fromMap(result.first);
    }
    return null;
  }

  Future<GuestBiodata?> getGuestBiodataByUserId(int userId) async {
    final db = await database;
    final result = await db.query(
      'guess_biodata',
      where: 'users_id = ?',
      whereArgs: [userId],
    );
    
    if (result.isNotEmpty) {
      return GuestBiodata.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateGuestBiodata(GuestBiodata guestBiodata) async {
    final db = await database;
    return await db.update(
      'guess_biodata',
      guestBiodata.toMap(),
      where: 'id = ?',
      whereArgs: [guestBiodata.id],
    );
  }

  // Guest Book operations
  Future<int> insertGuestBook(GuestBook guestBook) async {
    final db = await database;
    return await db.insert('guess_books', guestBook.toMap());
  }

  Future<List<GuestBook>> getAllGuestBooks() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT gb.*, gbd.full_name, gbd.email, gbd.phone_number, gbd.address
      FROM guess_books gb
      LEFT JOIN guess_biodata gbd ON gb.guess_id = gbd.id
      ORDER BY gb.created_at DESC
    ''');
    
    return result.map((map) {
      final guestBook = GuestBook.fromMap(map);
      final guestBiodata = GuestBiodata(
        id: map['guess_id'] as int,
        usersId: 0, // Not needed for display
        fullName: map['full_name'] as String? ?? '',
        email: map['email'] as String?,
        phoneNumber: map['phone_number'] as String?,
        address: map['address'] as String?,
      );
      return guestBook.copyWith(guestBiodata: guestBiodata);
    }).toList();
  }

  Future<GuestBook?> getGuestBookById(int id) async {
    final db = await database;
    final result = await db.query(
      'guess_books',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return GuestBook.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateGuestBook(GuestBook guestBook) async {
    final db = await database;
    return await db.update(
      'guess_books',
      guestBook.toMap(),
      where: 'id = ?',
      whereArgs: [guestBook.id],
    );
  }

  Future<int> deleteGuestBook(int id) async {
    final db = await database;
    return await db.delete(
      'guess_books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}