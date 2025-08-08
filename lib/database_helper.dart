import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'attendance.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mobile TEXT UNIQUE,
        name TEXT,
        dob TEXT,
        email TEXT
      )
    ''');

    // attendance table
    await db.execute('''
      CREATE TABLE attendance(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mobile TEXT,
        check_in_time TEXT,
        break_start_time TEXT,
        break_end_time TEXT,
        check_out_time TEXT,
        FOREIGN KEY(mobile) REFERENCES users(mobile)
      )
    ''');
  }

  // inserting user into db
  Future<void> insertUser(
    String mobile,
    String name,
    String dob,
    String email,
  ) async {
    final db = await database;
    await db.insert('users', {
      'mobile': mobile,
      'name': name,
      'dob': dob,
      'email': email,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //getUser by mobile no.
  Future<Map<String, dynamic>?> getUser(String mobile, String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'mobile = ?',
      whereArgs: [mobile],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // to record a check-in event.
  Future<void> insertCheckIn(String mobile) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    await db.insert('attendance', {
      'mobile': mobile,
      'check_in_time': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // to record break start event.
  Future<void> insertBreakStart(String mobile) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query(
      'attendance',
      where: 'mobile = ? AND check_out_time IS NULL',
      whereArgs: [mobile],
      orderBy: 'check_in_time DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final lastAttendanceId = maps.first['id'];
      await db.update(
        'attendance',
        {'break_start_time': now},
        where: 'id = ?',
        whereArgs: [lastAttendanceId],
      );
    }
  }

  //to update latest attendance record with a break end timestamp.
  Future<void> insertBreakEnd(String mobile) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query(
      'attendance',
      where: 'mobile = ? AND check_out_time IS NULL',
      whereArgs: [mobile],
      orderBy: 'check_in_time DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final lastAttendanceId = maps.first['id'];
      await db.update(
        'attendance',
        {'break_end_time': now},
        where: 'id = ?',
        whereArgs: [lastAttendanceId],
      );
    }
  }

  // to update latest attendance record with a check-out timestamp.
  Future<void> insertCheckOut(String mobile) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query(
      'attendance',
      where: 'mobile = ? AND check_out_time IS NULL',
      whereArgs: [mobile],
      orderBy: 'check_in_time DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final lastAttendanceId = maps.first['id'];
      await db.update(
        'attendance',
        {'check_out_time': now},
        where: 'id = ?',
        whereArgs: [lastAttendanceId],
      );
    }
  }

  // to retrieve the user's latest check-in time.
  Future<List<Map<String, dynamic>>> getAllAttendanceRecords(
    String mobile,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'attendance',
      where: 'mobile = ?',
      whereArgs: [mobile],
      orderBy: 'check_in_time ASC', // Order by check-in time ascending
    );
    return maps;
  }

  // Deletes the database for testing purposes.
  Future<void> deleteDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'attendance.db');
    await deleteDatabase(path);
    _database = null; // to reset the database instance
  }
  Future<void> updateUser(
    String oldMobile,
    String name,
    String newMobile,
    String dob,
    String email,
  ) async {
    final db = await database;
    
    // to check if the mobile number has actually changed in profile menu
    if (oldMobile != newMobile) {
      await db.transaction((txn) async {
        // 1. Update the user's mobile number in the 'users' table
        await txn.update(
          'users',
          {
            'name': name,
            'mobile': newMobile,
            'dob': dob,
            'email': email,
          },
          where: 'mobile = ?',
          whereArgs: [oldMobile],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // 2. Update the mobile number in all attendance records
        await txn.update(
          'attendance',
          {'mobile': newMobile},
          where: 'mobile = ?',
          whereArgs: [oldMobile],
        );
      });
    } else {
      //updating the users table if only other details are changed
      await db.update(
        'users',
        {
          'name': name,
          'dob': dob,
          'email': email,
        },
        where: 'mobile = ?',
        whereArgs: [oldMobile],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}




















