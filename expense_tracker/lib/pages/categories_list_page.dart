import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/pages/new_category_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesListPage extends StatefulWidget {
  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  @override
  void initState() {
    super.initState();

    Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorie'),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: () => Provider.of<CategoryProvider>(context, listen: false)
          .getAllCategories(),
      child: Consumer<CategoryProvider>(
          builder: ((context, categoryProvider, child) {
        return ListView.builder(
          itemCount: categoryProvider.categoryList.length,
          itemBuilder: (context, index) {
            final category = categoryProvider.categoryList[index];

            return Dismissible(
              key: Key(category.id.toString()),
              confirmDismiss: (_) {
                return categoryProvider.deleteCategory(category);
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(category.name),
                leading: category.icon,
                trailing: Container(
                  height: 20,
                  width: 20,
                  color: Color(category.colorValue),
                ),
              ),
            );
          },
        );
      })),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, NewCategoryPage.routeName),
    );
  }
}
