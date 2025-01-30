import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/category_controller.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/utils/color.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:drift/drift.dart' as drift hide Column;

class CategoryPage extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  CategoryPage({super.key});

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите цвет'),
          content: SingleChildScrollView(
            child: Obx(() => ColorPicker(
                  pickerColor: controller.categoryColor.value,
                  onColorChanged: (Color color) {
                    controller.updateCategoryColor(color);
                  },
                  pickerAreaHeightPercent: 0.8,
                )),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Готово'),
              onPressed: () {
                Navigator.of(context).pop();
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
        title: const Text('Новая категория'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Создайте новую категорию',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Добавьте название и выберите цвет для вашей категории',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Obx(() => TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Имя категории',
                    hintText: 'Например: Молочные продукты',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    prefixIcon: const Icon(Icons.category),
                    errorText: controller.categoryName.value.isEmpty
                        ? 'Пожалуйста, введите название категории'
                        : null,
                    errorStyle: TextStyle(
                      color: Theme.of(context).colorScheme.error.withAlpha((255 * 0.8).toInt()),
                      fontSize: 12,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error.withAlpha((255 * 0.5).toInt()),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) => controller.updateCategoryName(value),
                )),
            const SizedBox(height: 24),
            Obx(() => ListTile(
                  title: const Text('Цвет категории'),
                  subtitle: const Text('Нажмите, чтобы выбрать цвет'),
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: controller.categoryColor.value,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  onTap: () => _showColorPicker(context),
                )),
          ],
        ),
      ),
      floatingActionButton: Obx(() => FloatingActionButton.extended(
            label: const Text('Сохранить'),
            icon: const Icon(Icons.save),
            onPressed: controller.categoryName.value.isEmpty
                ? null
                : () async {
                    await AppDatabase.instance.insertCategory(
                      CategoryCompanion.insert(
                        name: controller.categoryName.value,
                        color:
                            drift.Value(controller.categoryColor.value.toInt()),
                      ),
                    );
                    Get.back();
                  },
            backgroundColor: controller.categoryName.value.isEmpty
                ? Colors.grey
                : Theme.of(context).primaryColor,
          )),
    );
  }
}
