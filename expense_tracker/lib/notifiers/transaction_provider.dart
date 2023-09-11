import 'package:expense_tracker/Database/database_transaction_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() {
    return [];
  }

  List<Transaction> get currentMonthTransactionList {
    final todayDate = DateTime.now();

    return state
        .where((element) =>
            element.date.month == todayDate.month &&
            element.date.year == todayDate.year)
        .toList();
  }

  double get totalBalance {
    return state.fold(
        0, (previousValue, element) => previousValue + element.value);
  }

  double getTotalBanalceUntilDate(DateTime date) {
    double totalBalance = 0;

    for (var transaction in state) {
      if (transaction.date.isBefore(date)) {
        totalBalance += transaction.value;
      }
    }

    return totalBalance;
  }

  List<Transaction> getTransactionListForAccount(Account account) {
    return state.where((element) => element.accountId == account.id).toList();
  }

  Future getTransactionsFromDb() async {
    state = await DatabaseTransactionHelper.instance.getAllTransactions();
  }

  Future<Transaction?> addNewTransaction({
    required String title,
    String? description,
    required double value,
    required DateTime date,
    Category? category,
    Account? account,
  }) async {
    Transaction newTransaction = Transaction(
      title: title,
      description: description,
      value: value,
      date: date,
      categoryId: category?.id,
      accountId: account?.id,
    );

    final addedTransaction = await DatabaseTransactionHelper.instance
        .insertTransaction(transaction: newTransaction);

    state = [...state, addedTransaction];

    return addedTransaction;
  }

  Future<Transaction?> addTransaction({
    required Transaction transaction,
    int? index,
  }) async {
    final addedTransaction = await DatabaseTransactionHelper.instance
        .insertTransaction(transaction: transaction);

    if (index != null) {
      final tempArray = List<Transaction>.of(state);
      tempArray.insert(index, addedTransaction);

      state = tempArray;
    } else {
      state = [...state, addedTransaction];
    }

    return addedTransaction;
  }

  Future updateTransaction({
    required Transaction transactionToEdit,
    required String title,
    String? description,
    required double value,
    required DateTime date,
    required Category? category,
    required Account? account,
  }) async {
    final modifiedTransaction = Transaction(
      id: transactionToEdit.id,
      title: title,
      description: description,
      value: value,
      date: date,
      categoryId: category?.id,
      accountId: account?.id,
    );

    if (await DatabaseTransactionHelper.instance.updateTransaction(
        transactionToEdit: transactionToEdit,
        modifiedTransaction: modifiedTransaction)) {
      final transactionIndexToModify =
          state.indexWhere((element) => element.id == transactionToEdit.id);

      if (transactionIndexToModify != -1) {
        final tempList = List<Transaction>.of(state);
        tempList[transactionIndexToModify] = modifiedTransaction;

        state = tempList;
      }
    }
  }

  /// Removes a transaction and returns the index of the old position
  Future<(bool, int)> deleteTransaction(Transaction transaction) async {
    final removedTransactionCount = await DatabaseTransactionHelper.instance
        .deleteTransaction(transaction: transaction);

    if (removedTransactionCount > 0) {
      final tempList = List<Transaction>.of(state);
      final index =
          tempList.indexWhere((element) => element.id == transaction.id);

      tempList.removeAt(index);

      state = tempList;

      return (true, index);
    }

    return (false, -1);
  }

  /// Returns a Map where for each month of the year, there is a sum of all the transactions value
  Map<int, double> getMonthlyBalanceForYear(int year) {
    final Map<int, double> balanceMap = {};

    final currentYearTransactions =
        state.where((element) => element.date.year == year);

    for (var transaction in currentYearTransactions) {
      balanceMap[transaction.date.month] =
          (balanceMap[transaction.date.month] ?? 0) + transaction.value;
    }

    return balanceMap;
  }
}

final transactionProvider =
    NotifierProvider<TransactionNotifier, List<Transaction>>(() {
  return TransactionNotifier();
});
