import 'package:expense_tracker/Helper/database_category_helper.dart';
import 'package:expense_tracker/Helper/database_transaction_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    print(dbPath);

    if (_database != null) return _database!;

    _database = await _initDB();

    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'myDb2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await DatabaseCategoryHelper.inizializeTable(db);
    await DatabaseTransactionHelper.inizializeTable(db);
  }
}
