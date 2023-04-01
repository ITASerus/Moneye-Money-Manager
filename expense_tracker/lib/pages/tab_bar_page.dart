import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/accounts_page/accounts_list_page.dart';
import 'package:expense_tracker/pages/categories_page/categories_list_page.dart';
import 'package:expense_tracker/pages/home_page/home_page.dart';
import 'package:expense_tracker/pages/options_page/options_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({Key? key}) : super(key: key);

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  int index = 0;

  final screen = [
    const HomePage(),
    const OptionsPage(),
  ];

  @override
  void initState() {
    super.initState();

    Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
    Provider.of<AccountProvider>(context, listen: false).getAllAccounts();
    Provider.of<TransactionProvider>(context, listen: false)
        .getAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: index,
          selectedItemColor: CustomColors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (newIndex) {
            setState(() => index = newIndex);
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.money),
              title: const Text('Spese'),
              //  selectedColor: Colors.purple,
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.gear_solid),
              title: const Text('Opzioni'),
              //  selectedColor: Colors.purple,
            ),
          ],
        ),
        body: screen[index]);
  }
}
