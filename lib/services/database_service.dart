import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/illness.dart';
import '../models/medicine.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('careloop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE illnesses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        illness_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        stock INTEGER NOT NULL,
        frequency INTEGER NOT NULL,
        times TEXT NOT NULL,
        FOREIGN KEY (illness_id) REFERENCES illnesses (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<Illness> createIllness(Illness illness) async {
    final db = await database;
    final id = await db.insert('illnesses', illness.toMap());
    return illness.copyWith(id: id);
  }

  Future<List<Illness>> getActiveIllnesses() async {
    final db = await database;
    final result = await db.query(
      'illnesses',
      where: 'is_active = ?',
      whereArgs: [1],
    );
    return result.map((e) => Illness.fromMap(e)).toList();
  }

  Future<List<Illness>> getInactiveIllnesses() async {
    final db = await database;
    final result = await db.query(
      'illnesses',
      where: 'is_active = ?',
      whereArgs: [0],
    );
    return result.map((e) => Illness.fromMap(e)).toList();
  }

  Future<void> updateIllness(Illness illness) async {
    final db = await database;
    await db.update(
      'illnesses',
      illness.toMap(),
      where: 'id = ?',
      whereArgs: [illness.id],
    );
  }

  Future<void> deleteIllness(int id) async {
    final db = await database;
    await db.delete('illnesses', where: 'id = ?', whereArgs: [id]);
  }

  Future<Medicine> createMedicine(Medicine medicine) async {
    final db = await database;
    final id = await db.insert('medicines', medicine.toMap());
    return medicine.copyWith(id: id);
  }

  Future<List<Medicine>> getMedicinesByIllness(int illnessId) async {
    final db = await database;
    final result = await db.query(
      'medicines',
      where: 'illness_id = ?',
      whereArgs: [illnessId],
    );
    return result.map((e) => Medicine.fromMap(e)).toList();
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final db = await database;
    await db.update(
      'medicines',
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<void> updateStock(int medicineId, int newStock) async {
    final db = await database;
    await db.update(
      'medicines',
      {'stock': newStock},
      where: 'id = ?',
      whereArgs: [medicineId],
    );
  }

  Future<void> deleteMedicine(int id) async {
    final db = await database;
    await db.delete('medicines', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
