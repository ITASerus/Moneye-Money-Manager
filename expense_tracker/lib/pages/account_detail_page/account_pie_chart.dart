import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

enum AccountPieChartModeTime { month, year, all }

enum AccountPieChartModeTransactionType { income, expense, all }

class AccountPieChart extends StatefulWidget {
  final List<Transaction> transactionList;
  final AccountPieChartModeTransactionType? mode;

  const AccountPieChart({
    super.key,
    required this.transactionList,
    this.mode,
  });

  @override
  State<AccountPieChart> createState() => _AccountPieChartState();
}

class _AccountPieChartState extends State<AccountPieChart> {
  int touchedIndex = -1;

  Map<int, double> categoryTotalValueMap = {};
  final List<CategoryTotalValue> categoryTotalValuePairs = [];
  double totalValue = 0;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  void didUpdateWidget(covariant AccountPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                sections: showingSections(),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...categoryTotalValuePairs
                .map(
                  (e) => Indicator(
                    color: e.category.color,
                    text: e.category.name,
                    value: (e.totalValue / totalValue) * 100,
                  ),
                )
                .toList()
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      categoryTotalValuePairs.length,
      (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 50.0 : 40.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

        return PieChartSectionData(
            color: categoryTotalValuePairs[i].category.color,
            value: categoryTotalValuePairs[i].totalValue,
            showTitle: false,
            title: categoryTotalValuePairs[i].category.name,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            badgeWidget: categoryTotalValuePairs[i].category.iconPath != null
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: SvgPicture.asset(
                      categoryTotalValuePairs[i].category.iconPath!,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  )
                : null);
      },
    );
  }

  _loadData() {
    categoryTotalValuePairs.clear();
    totalValue = 0;

    if (widget.mode == AccountPieChartModeTransactionType.all) {
      final incomeCategory = CategoryTotalValue(
        category:
            Category(id: -1, name: 'Entrate', colorValue: Colors.green.value),
        totalValue: 0,
      );

      final outcomeCategory = CategoryTotalValue(
        category:
            Category(id: -2, name: 'Uscite', colorValue: Colors.red.value),
        totalValue: 0,
      );

      categoryTotalValuePairs.add(incomeCategory);
      categoryTotalValuePairs.add(outcomeCategory);

      for (var transaction in widget.transactionList) {
        totalValue += transaction.value.abs();

        if (transaction.value >= 0) {
          categoryTotalValuePairs[0].totalValue += transaction.value;
        } else {
          categoryTotalValuePairs[1].totalValue += transaction.value;
        }
      }

      totalValue = totalValue.abs();
      categoryTotalValuePairs[1].totalValue *= -1;
    } else {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);

      categoryTotalValuePairs.clear();
      totalValue = 0;

      for (var transaction in widget.transactionList) {
        totalValue += transaction.value;

        if (transaction.categoryId != null) {
          final category =
              categoryProvider.getCategoryFromId(transaction.categoryId!);

          final indexFound = categoryTotalValuePairs
              .indexWhere((element) => element.category == category);

          if (indexFound != -1) {
            categoryTotalValuePairs[indexFound].totalValue += transaction.value;
          } else {
            final newEntry = CategoryTotalValue(
              category: category!,
              totalValue: transaction.value,
            );

            categoryTotalValuePairs.add(newEntry);
          }
        } else {
          final indexFound = categoryTotalValuePairs
              .indexWhere((element) => element.category.id == -1);

          if (indexFound != -1) {
            categoryTotalValuePairs[indexFound].totalValue += transaction.value;
          } else {
            final otherEntry = CategoryTotalValue(
                category: Category(
                    id: -1, name: 'Altro', colorValue: Colors.grey.value),
                totalValue: transaction.value);

            categoryTotalValuePairs.add(otherEntry);
          }
        }
      }
    }
  }
}

class CategoryTotalValue {
  final Category category;
  double totalValue;

  CategoryTotalValue({required this.category, required this.totalValue});
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final double? value;

  const Indicator(
      {super.key, required this.color, required this.text, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              text,
            ),
          ),
          if (value != null)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text('${value!.toStringAsFixed(2)}%'),
            )
        ],
      ),
    );
  }
}
