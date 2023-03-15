import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/categories_page/new_category_page.dart';
import 'package:expense_tracker/pages/accounts_page/new_account_page.dart';
import 'package:expense_tracker/pages/new_transaction_flow/new_transaction_page.dart';
import 'package:expense_tracker/pages/tab_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProxyProvider<AccountProvider, TransactionProvider>(
            create: (_) => TransactionProvider(),
            update: (context, accountProvider, transactionProvider) =>
                transactionProvider!..accountProvider = accountProvider)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const TabBarPage(),
          NewCategoryPage.routeName: (context) => const NewCategoryPage(),
          NewAccountPage.routeName: (context) => const NewAccountPage(),
          NewTransactionPage.routeName: (context) => const NewTransactionPage()
        },
        // onGenerateRoute: (settings) {
        //   if (settings.name == NewTransactionPage.routeName) {
        //     final args = settings.arguments as DateTime;

        //     return MaterialPageRoute(
        //       builder: (context) {
        //         return NewTransactionPage(
        //           date: args,
        //         );
        //       },
        //     );
        //   }
        //   assert(false, 'Need to implement ${settings.name}');
        //   return null;
        // },
      ),
    );
  }
}
