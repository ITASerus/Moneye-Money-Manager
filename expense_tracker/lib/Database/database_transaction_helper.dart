import 'package:expense_tracker/Database/database_helper.dart';
import 'package:expense_tracker/Database/database_types.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';

import 'package:expense_tracker/models/transaction.dart' as trans;
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseTransactionHelper {
  static final DatabaseTransactionHelper instance =
      DatabaseTransactionHelper._init();
  DatabaseTransactionHelper._init();

  static Future inizializeTable(Database db) async {
    await db.execute('''
    CREATE TABLE $transactionsTable (
      ${TransactionFields.id} ${DatabaseTypes.idType},
      ${TransactionFields.title} ${DatabaseTypes.textType},
      ${TransactionFields.description} ${DatabaseTypes.textTypeNullable},
      ${TransactionFields.amount} ${DatabaseTypes.realType},
      ${TransactionFields.date} ${DatabaseTypes.dateTimeType},
      ${TransactionFields.categoryId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionFields.accountId} ${DatabaseTypes.integerTypeNullable},
      ${TransactionFields.isHidden} ${DatabaseTypes.integerType} DEFAULT 0,
      FOREIGN KEY (${TransactionFields.categoryId}) REFERENCES $categoriesTable (${CategoryFields.id}) ON DELETE SET NULL ON UPDATE NO ACTION,
      FOREIGN KEY (${TransactionFields.accountId}) REFERENCES $accountsTable (${AccountFields.id}) ON DELETE CASCADE ON UPDATE NO ACTION
      )
    ''');

    // await insertDemoData(db);
  }

  // Update DB functions
  static void updateTransactionTableV1toV2(Batch batch) {
    print("UPDATE FROM V1 TO V2");
    batch.execute(
        '''ALTER TABLE $transactionsTable RENAME value TO ${TransactionFields.amount}''');
    batch.execute(
        '''ALTER TABLE $transactionsTable ADD ${TransactionFields.isHidden} ${DatabaseTypes.integerType} DEFAULT 0''');
  }

  static Future insertDemoData(Database db) async {
    List<trans.Transaction> transactionList = [
      trans.Transaction(
        id: 1,
        title: 'Gas for car',
        amount: -20,
        date: DateTime(2023, 5, 1),
        categoryId: 5,
        accountId: 1,
      ),
      trans.Transaction(
        id: 2,
        title: 'Balance',
        amount: 500,
        date: DateTime(2023, 3, 1),
        accountId: 1,
      ),
      trans.Transaction(
        id: 3,
        title: 'Balance',
        amount: 500,
        date: DateTime(2023, 3, 1),
        accountId: 3,
      ),
      trans.Transaction(
        id: 4,
        title: 'Movie tickets',
        amount: -15,
        date: DateTime(2023, 5, 4),
        categoryId: 7,
        accountId: 3,
      ),
      trans.Transaction(
        id: 5,
        title: 'Electricity bill',
        amount: -75,
        date: DateTime(2023, 5, 7),
        categoryId: 1,
        accountId: 3,
      ),
      trans.Transaction(
        id: 6,
        title: 'Gift for Mike',
        amount: -50,
        date: DateTime(2023, 5, 2),
        categoryId: 2,
        accountId: 3,
      ),
      trans.Transaction(
        id: 7,
        title: 'Rome trip',
        amount: -100,
        date: DateTime(2023, 5, 13),
        categoryId: 3,
        accountId: 3,
      ),
      trans.Transaction(
        id: 8,
        title: 'Gas for car',
        amount: -200,
        date: DateTime(2023, 4, 11),
        categoryId: 5,
        accountId: 1,
      ),
      trans.Transaction(
        id: 9,
        title: 'Balance',
        amount: -234,
        date: DateTime(2023, 3, 17),
        accountId: 1,
      ),
      trans.Transaction(
        id: 10,
        title: 'Balance',
        amount: 100,
        date: DateTime(2023, 2, 1),
        accountId: 3,
      ),
      trans.Transaction(
        id: 11,
        title: 'Movie tickets',
        amount: -15,
        date: DateTime(2023, 3, 4),
        categoryId: 7,
        accountId: 3,
      ),
      trans.Transaction(
        id: 12,
        title: 'Electricity bill',
        amount: -75,
        date: DateTime(2023, 1, 13),
        categoryId: 1,
        accountId: 3,
      ),
      trans.Transaction(
        id: 13,
        title: 'Gift for Mike',
        amount: -50,
        date: DateTime(2023, 4, 12),
        categoryId: 2,
        accountId: 3,
      ),
      trans.Transaction(
        id: 14,
        title: 'Rome trip',
        amount: -100,
        date: DateTime(2023, 2, 13),
        categoryId: 3,
        accountId: 3,
      ),
      trans.Transaction(
        id: 15,
        title: 'Gas for car',
        amount: -200,
        date: DateTime(2023, 5, 22),
        categoryId: 5,
        accountId: 3,
      ),
      trans.Transaction(
        id: 16,
        title: 'Balance',
        amount: -234,
        date: DateTime(2023, 5, 23),
        accountId: 3,
      ),
      trans.Transaction(
        id: 17,
        title: 'Balance',
        amount: 100,
        date: DateTime(2023, 5, 24),
        accountId: 3,
      ),
      trans.Transaction(
        id: 18,
        title: 'Movie tickets',
        amount: -15,
        date: DateTime(2023, 5, 25),
        categoryId: 7,
        accountId: 3,
      ),
      trans.Transaction(
        id: 19,
        title: 'Electricity bill',
        amount: -75,
        date: DateTime(2023, 5, 26),
        categoryId: 1,
        accountId: 3,
      ),
      trans.Transaction(
        id: 20,
        title: 'Gift for Mike',
        amount: -50,
        date: DateTime(2023, 5, 27),
        categoryId: 2,
        accountId: 3,
      ),
      trans.Transaction(
        id: 21,
        title: 'Rome trip',
        amount: -100,
        date: DateTime(2023, 5, 28),
        categoryId: 3,
        accountId: 3,
      ),
      trans.Transaction(
        id: 22,
        title: 'Dog bath',
        amount: -45,
        date: DateTime(2023, 7, 1),
        categoryId: 9,
        accountId: 3,
      ),
      trans.Transaction(
        id: 23,
        title: 'New jeans',
        amount: -67,
        date: DateTime(2023, 7, 2),
        categoryId: 4,
        accountId: 3,
      ),
      trans.Transaction(
        id: 24,
        title: 'Bus ticket',
        amount: -4.5,
        date: DateTime(2023, 7, 3),
        categoryId: 5,
        accountId: 3,
      ),
      trans.Transaction(
        id: 25,
        title: 'New towel',
        amount: -32,
        date: DateTime(2023, 7, 4),
        categoryId: 6,
        accountId: 3,
      ),
      trans.Transaction(
        id: 26,
        title: 'Lasertag match',
        amount: -8,
        date: DateTime(2023, 7, 5),
        categoryId: 7,
        accountId: 3,
      ),
      trans.Transaction(
        id: 27,
        title: 'Pub',
        amount: -34,
        date: DateTime(2023, 7, 12),
        categoryId: 8,
        accountId: 3,
      ),
      trans.Transaction(
        id: 28,
        title: 'Food for Yaki',
        amount: -87,
        date: DateTime(2023, 6, 12),
        categoryId: 9,
        accountId: 3,
      ),
      trans.Transaction(
        id: 29,
        title: 'Gym membership',
        amount: -22,
        date: DateTime(2023, 7, 3),
        categoryId: 10,
        accountId: 3,
      ),
      trans.Transaction(
        title: 'Water bill',
        amount: -44,
        date: DateTime(2023, 7, 4),
        categoryId: 1,
        accountId: 3,
      ),
      trans.Transaction(
        title: 'Gift for Erika',
        amount: -25,
        date: DateTime(2023, 7, 5),
        categoryId: 2,
        accountId: 3,
      ),
      trans.Transaction(
        title: 'Refound online purchase',
        amount: 125,
        date: DateTime(2023, 7, 12),
        categoryId: 6,
        accountId: 3,
      ),
      trans.Transaction(
        title: 'Videogame sold',
        amount: 37,
        date: DateTime(2023, 7, 27),
        categoryId: 7,
        accountId: 3,
      ),
    ];

    for (final transaction in transactionList) {
      await db.insert(transactionsTable, transaction.toJson());
    }
  }

  Future<trans.Transaction> insertTransaction(
      {required trans.Transaction transaction}) async {
    final db = await DatabaseHelper.instance.database;

    final id = await db.insert(transactionsTable, transaction.toJson());

    return transaction.copy(id: id);
  }

  Future<bool> updateTransaction(
      {required trans.Transaction transactionToEdit,
      required trans.Transaction modifiedTransaction}) async {
    final db = await DatabaseHelper.instance.database;

    if (await db.update(transactionsTable, modifiedTransaction.toJson(),
            where: '${trans.TransactionFields.id} = ?',
            whereArgs: [transactionToEdit.id]) >
        0) {
      return true;
    }

    return false;
  }

  /// Returns the number of the row deleted
  Future<int> deleteTransaction(
      {required trans.Transaction transaction}) async {
    final db = await DatabaseHelper.instance.database;

    return db.delete(
      transactionsTable,
      where: '${TransactionFields.id} = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<trans.Transaction> getTransactionFromId(int id) async {
    final db = await DatabaseHelper.instance.database;

    final maps = await db.query(
      transactionsTable,
      columns: TransactionFields.values,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return trans.Transaction.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<trans.Transaction>> getAllTransactions() async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${TransactionFields.date} ASC';

    final result = await db.query(transactionsTable, orderBy: orderBy);
    return result.map((json) => trans.Transaction.fromJson(json)).toList();
  }

  Future<List<trans.Transaction>> getTransactionsBetweenDates(
      {required DateTime startDate, required DateTime endDate}) async {
    final db = await DatabaseHelper.instance.database;

    const orderBy = '${TransactionFields.date} ASC';

    final result = await db.query(transactionsTable,
        orderBy: orderBy,
        where:
            "${TransactionFields.date} BETWEEN date(?, 'localtime') AND date(?, 'localtime')",
        whereArgs: [
          DateFormat('yyyy-MM-dd').format(startDate).toString(),
          DateFormat('yyyy-MM-dd').format(endDate).toString(),
        ]);

    return result.map((json) => trans.Transaction.fromJson(json)).toList();
  }
}
