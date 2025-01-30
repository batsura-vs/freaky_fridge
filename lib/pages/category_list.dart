import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/category_controller.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/pages/creation/category.dart';
import 'package:freaky_fridge/utils/color.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoryListScreen extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  CategoryListScreen({super.key});

  void _showColorPicker(BuildContext context, CategoryData category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color pickerColor = Color(category.color);
        return AlertDialog(
          title: const Text('Выберите цвет'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () async {
                await AppDatabase.instance
                    .update(AppDatabase.instance.category)
                    .replace(category.copyWith(color: pickerColor.toInt()));
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        elevation: 0,
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
        stream: AppDatabase.instance.select(AppDatabase.instance.category).watch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.5).toInt()),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет категорий',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.7).toInt()),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Нажмите + чтобы добавить',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.5).toInt()),
                        ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Color(category.color),
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.color_lens),
                          onPressed: () => _showColorPicker(context, category),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditDialog(context, category),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Удалить категорию?'),
                              content: Text(
                                  'Вы уверены, что хотите удалить категорию "${category.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
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
                            ),
                          ),
                        ),
                      ],
                    ),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название категории',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
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
}
