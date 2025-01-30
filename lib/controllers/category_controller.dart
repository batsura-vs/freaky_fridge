import 'package:get/get.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:flutter/material.dart';

class CategoryController extends GetxController {
  var categoryName = ''.obs;
  var categoryColor = const Color(0xFF9C27B0).obs;  // Default purple color

  void updateCategoryName(String name) {
    categoryName.value = name;
  }

  void updateCategoryColor(Color color) {
    categoryColor.value = color;
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