import 'package:collection/collection.dart';
import 'package:expense_tracker/Database/database_category_helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryNotifier extends Notifier<List<Category>> {
  @override
  List<Category> build() {
    return [];
  }

  Future getCategoriesFromDb() async {
    state = await DatabaseCategoryHelper.instance.readAllCategories();
  }

  Category? getCategoryForTransaction(Transaction transaction) {
    return state
        .firstWhereOrNull((element) => element.id == transaction.categoryId);
  }

  Future addNewCategoryByParameters({
    required String name,
    String? description,
    required int? colorValue,
    required String? iconPath,
  }) async {
    final newCategory = Category(
      name: name,
      description: description,
      colorValue: colorValue,
      iconPath: iconPath,
    );

    final addedCategory = await DatabaseCategoryHelper.instance
        .insertCategory(category: newCategory);

    state = [...state, addedCategory];
  }

  Future addNewCategory({required Category category}) async {
    final addedCategory = await DatabaseCategoryHelper.instance
        .insertCategory(category: category);

    state = [...state, addedCategory];
  }

  Future updateCategory({
    required Category categoryToEdit,
    required String name,
    String? description,
    required int? colorValue,
    required String? iconPath,
  }) async {
    final modifiedCategory = Category(
      id: categoryToEdit.id,
      name: name,
      description: description,
      colorValue: colorValue,
      iconPath: iconPath,
    );

    if (await DatabaseCategoryHelper.instance.updateCategory(
        categoryToEdit: categoryToEdit, modifiedCategory: modifiedCategory)) {
      final categoryIndexToModify =
          state.indexWhere((element) => element.id == categoryToEdit.id);

      if (categoryIndexToModify != -1) {
        final tempList = List<Category>.of(state);
        tempList[categoryIndexToModify] = modifiedCategory;

        state = tempList;
      }
    }
  }

  /// Deletes the category without affecting the transactions viewed in the current session
  Future<bool> deleteCategory(Category category) async {
    final removedCategoryCount = await DatabaseCategoryHelper.instance
        .deleteCategory(category: category);

    if (removedCategoryCount > 0) {
      final tempList = List<Category>.of(state);
      tempList.removeWhere((element) => element.id == category.id);

      state = tempList;

      return true;
    }

    return false;
  }

  Category? getCategoryFromId(int id) {
    return state.firstWhereOrNull((element) => element.id == id);
  }

  /// Deletes the category affecting the transactions viewed in the current session
  Future<bool> deleteCategoryCentral(Category category) async {
    final isCategorytDeleted = await deleteCategory(category);

    if (isCategorytDeleted) {
      final transactionList = ref.read(transactionProvider);

      for (var transaction in transactionList) {
        if (transaction.categoryId == category.id) {
          transaction.categoryId = null;
        }
      }

      return true;
    }

    return false;
  }
}

final categoryProvider = NotifierProvider<CategoryNotifier, List<Category>>(() {
  return CategoryNotifier();
});
