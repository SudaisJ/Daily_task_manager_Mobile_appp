import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._internal();
  factory TaskRepository() => _instance;
  TaskRepository._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'tasks_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            title TEXT,
            description TEXT,
            priority TEXT,
            dueDate TEXT,
            isCompleted INTEGER,
            FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              email TEXT UNIQUE,
              password TEXT
            )
          ''');
          await db.execute('ALTER TABLE tasks ADD COLUMN userId INTEGER');
        }
      },
    );
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<bool> registerUser(User user) async {
    final db = await database;
    try {
      await db.insert('users', user.toMap());
      return true;
    } catch (e) {
      return false; // Email already exists or db error
    }
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ? AND userId = ?',
      whereArgs: [task.id, task.userId],
    );
  }

  Future<int> deleteTask(int id, int userId) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }
}
