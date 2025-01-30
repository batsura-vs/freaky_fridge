import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/category_controller.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart';

class CategoryPage extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая категория'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Имя категории',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.updateCategoryName(value),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Сохранить'),
        icon: const Icon(Icons.save),
        onPressed: () async {
          await AppDatabase.instance.insertCategory(
            CategoryCompanion.insert(
              name: controller.categoryName.value,
            ),
          );
          Get.back();
        },
      ),
    );
  }
}
