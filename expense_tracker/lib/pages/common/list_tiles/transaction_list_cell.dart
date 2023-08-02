import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';

import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart' as p;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionListCell extends ConsumerWidget {
  final Transaction transaction;
  final double horizontalPadding;

  final bool showAccountLabel;

  const TransactionListCell({
    Key? key,
    required this.transaction,
    bool? dismissible = true,
    this.horizontalPadding = 17,
    this.showAccountLabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: Key(transaction.id.toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
            onDismissed: () async => await _removeTransaction(context)),
        children: [
          _buildDeleteAction(context),
          // _buildEditAction(),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
            onDismissed: () async => await _removeTransaction(context)),
        children: [
          // _buildEditAction(),
          _buildDeleteAction(context),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          NewEditTransactionPage.routeName,
          arguments:
              NewEditTransactionPageScreenArguments(transaction: transaction),
        ),
        child: Container(
          height: 64,
          padding:
              EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
          child: Row(
            children: [
              _buildCategoryIcon(context),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    _buildDate(context),
                  ],
                ),
              ),
              _buildValue(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  _buildCategoryIcon(BuildContext context) {
    final category = p.Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryForTransaction(transaction);

    SvgPicture? categoryIcon;
    if (category != null && category.iconPath != null) {
      categoryIcon = SvgPicture.asset(
        category.iconPath!,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: category != null ? category.color : Colors.grey),
      child: categoryIcon,
    );
  }

  Widget _buildDate(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    String dateString = transaction.date.toIso8601String().substring(0, 10);

    DateTime dateToCheck = DateTime(
        transaction.date.year, transaction.date.month, transaction.date.day);

    if (dateToCheck == today) {
      dateString = '$dateString (${AppLocalizations.of(context)!.today})';
    } else if (dateToCheck == yesterday) {
      dateString = '$dateString (${AppLocalizations.of(context)!.yesterday})';
    }

    return Flexible(
      child: Text(
        dateString,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }

  Widget _buildValue(BuildContext context, WidgetRef ref) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    Account? account;

    if (showAccountLabel && transaction.accountId != null) {
      account = p.Provider.of<AccountProvider>(context, listen: false)
          .getAccountFromId(transaction.accountId!);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          transaction.value.toStringAsFixedRoundedWithCurrency(
              2, currentCurrency, currentCurrencyPosition),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: transaction.value >= 0 ? Colors.green : Colors.red,
          ),
        ),
        if (showAccountLabel && account != null)
          Text(
            account.name,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
      ],
    );
  }

  SlidableAction _buildDeleteAction(BuildContext context) {
    return SlidableAction(
      onPressed: (context) async => await _removeTransaction(context),
      backgroundColor: const Color(0xFFFE4A49),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: AppLocalizations.of(context)!.delete,
    );
  }

  // SlidableAction _buildEditAction() {
  //   return SlidableAction(
  //     onPressed: (context) => Navigator.of(context)
  //         .pushNamed(NewTransactionPage.routeName, arguments: transaction),
  //     backgroundColor: const Color(0xFF21B7CA),
  //     foregroundColor: Colors.white,
  //     icon: Icons.edit,
  //     label: 'Modifica',
  //   );
  // }

  Future _removeTransaction(BuildContext context) async {
    await p.Provider.of<TransactionProvider>(context, listen: false)
        .deleteTransaction(transaction);
  }
}
