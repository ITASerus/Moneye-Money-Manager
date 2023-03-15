import 'package:expense_tracker/Helper/Database/database_account_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';

class AccountProvider with ChangeNotifier {
  List<Account> accountList = [];

  AccountProvider() {
    getAllAccounts();
  }

  Future getAllAccounts() async {
    accountList = await DatabaseAccountHelper.instance.getAllAccounts();

    notifyListeners();
  }

  Future addNewAccount({required Account newAccount}) async {
    accountList.add(await DatabaseAccountHelper.instance
        .insertAccount(account: newAccount));

    notifyListeners();
  }

  Future<bool> deleteAccount(Account account) async {
    final removedAccountCount =
        await DatabaseAccountHelper.instance.deleteAccount(account: account);

    if (removedAccountCount > 0) {
      accountList.removeWhere((element) => element.id == account.id);

      notifyListeners();

      return true;
    }

    return false;
  }
}
