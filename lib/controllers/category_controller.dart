import 'package:get/get.dart';
import 'package:freaky_fridge/database/database.dart';

class CategoryController extends GetxController {
  var categoryName = ''.obs;

  void updateCategoryName(String name) {
    categoryName.value = name;
  }

  Future<void> updateCategory(CategoryData category) async {
    await AppDatabase.instance.update(AppDatabase.instance.category)
        .replace(category);
  }

  Future<void> deleteCategory(int id) async {
    await (AppDatabase.instance.delete(AppDatabase.instance.category)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}