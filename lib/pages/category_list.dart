import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/category_controller.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/pages/creation/category.dart';
import 'package:get/get.dart';

class CategoryListScreen extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => CategoryPage());
            },
          ),
        ],
      ),
      body: StreamBuilder<List<CategoryData>>(
        stream: AppDatabase.instance
            .select(AppDatabase.instance.category)
            .watch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Пока нет категорий.'));
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, category);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(context, category);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, CategoryData category) {
    final TextEditingController nameController =
        TextEditingController(text: category.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать категорию'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Название категории'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                await AppDatabase.instance
                    .update(AppDatabase.instance.category)
                    .replace(category.copyWith(name: nameController.text));
                Get.back();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, CategoryData category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Удалить категорию'),
          content: Text(
              'Вы уверены, что хотите удалить категорию "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                await controller.deleteCategory(category.id);
                Get.back();
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }
}
