import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/pages/categories_page/new_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CategoryListCell extends StatelessWidget {
  final Category category;

  const CategoryListCell({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(category.id.toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () async =>
              await Provider.of<CategoryProvider>(context, listen: false)
                  .deleteCategory(category),
        ),
        children: [
          _buildDeleteAction(),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () async =>
              await Provider.of<CategoryProvider>(context, listen: false)
                  .deleteCategory(category),
        ),
        children: [
          _buildDeleteAction(),
        ],
      ),
      child: ListTile(
        onTap: () => Navigator.of(context)
            .pushNamed(NewCategoryPage.routeName, arguments: category),
        title: Text(
          category.name,
          style: const TextStyle(fontSize: 16),
        ),
        leading: _buildCategoryIcon(category),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  _buildCategoryIcon(Category category) {
    SvgPicture? categoryIcon;
    if (category.iconPath != null) {
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(shape: BoxShape.circle, color: category.color),
      child: categoryIcon,
    );
  }

  SlidableAction _buildDeleteAction() {
    return SlidableAction(
      onPressed: (context) async =>
          await Provider.of<CategoryProvider>(context, listen: false)
              .deleteCategory(category),
      backgroundColor: const Color(0xFFFE4A49),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: 'Elimina',
    );
  }
}
