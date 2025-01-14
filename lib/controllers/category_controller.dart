import 'package:get/get.dart';
import 'package:freaky_fridge/database/database.dart';

class CategoryController extends GetxController {
  var categoryName = ''.obs;

  void updateCategoryName(String name) {
    categoryName.value = name;
  }

  Future<void> updateCategory(CategoryData category) async {
    await ProductDatabase.instance.update(ProductDatabase.instance.category)
        .replace(category);
  }

  Future<void> deleteCategory(int id) async {
    await (ProductDatabase.instance.delete(ProductDatabase.instance.category)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}