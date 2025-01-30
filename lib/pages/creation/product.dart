import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/product_controller.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/pages/category_list.dart';
import 'package:get/get.dart' hide Value;
import 'package:intl/intl.dart';

class ProductPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  static const double _padding = 16.0;
  static const double _borderRadius = 12.0;
  static const double _spacing = 20.0;

  ProductPage({super.key, ProductData? product}) {
    if (product != null) {
      controller.updateProduct(product);
    }
  }

  InputDecoration _buildInputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            title: Text(
              controller.id.value == -1
                  ? "Новый продукт"
                  : "Редактировать продукт",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              if (controller.id.value != -1)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Подтверждение"),
                          content: const Text(
                              "Вы уверены, что хотите удалить этот продукт?"),
                          actions: [
                            TextButton(
                              child: const Text("Отмена"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: const Text("Удалить",
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                AppDatabase.instance
                                    .deleteProduct(controller.id.value);
                                Navigator.of(context).pop();
                                Get.back();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: _padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: _spacing),
                    Obx(
                      () => TextFormField(
                        initialValue: controller.name.value,
                        decoration: _buildInputDecoration('Название'),
                        onChanged: (value) => controller.updateName(value),
                      ),
                    ),
                    const SizedBox(height: _spacing),
                    Obx(
                      () => TextFormField(
                        initialValue: controller.description.value,
                        minLines: 3,
                        maxLines: 5,
                        decoration: _buildInputDecoration('Описание'),
                        onChanged: (value) =>
                            controller.updateDescription(value),
                      ),
                    ),
                    const SizedBox(height: _spacing),
                    StreamBuilder<List<CategoryData>>(
                      stream: AppDatabase.instance
                          .select(AppDatabase.instance.category)
                          .watch(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final categories = snapshot.data!;
                        return Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: categories
                                        .firstWhereOrNull((category) =>
                                            category.id == controller.category)
                                        ?.id ??
                                    -1,
                                decoration: _buildInputDecoration('Категория'),
                                items: [
                                  const DropdownMenuItem<int>(
                                    value: -1,
                                    child: Text('Не выбрано'),
                                  ),
                                  ...categories.map((category) {
                                    return DropdownMenuItem<int>(
                                      value: category.id,
                                      child: Text(category.name),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.updateCategory(value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              style: IconButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .primaryColor
                                    .withAlpha((255 * 0.1).toInt()),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(_borderRadius),
                                ),
                              ),
                              onPressed: () =>
                                  Get.to(() => CategoryListScreen()),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: _spacing),
                    Obx(
                      () => TextFormField(
                        decoration: _buildInputDecoration(
                          'Дата изготовления',
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: controller.manufactureDate.value,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.updateManufactureDate(picked);
                          }
                        },
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd')
                              .format(controller.manufactureDate.value),
                        ),
                      ),
                    ),
                    const SizedBox(height: _spacing),
                    Obx(
                      () => TextFormField(
                        decoration: _buildInputDecoration(
                          'Срок годности',
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: controller.expirationDate.value,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.updateExpirationDate(picked);
                          }
                        },
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd')
                              .format(controller.expirationDate.value),
                        ),
                      ),
                    ),
                    const SizedBox(height: _spacing),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Obx(
                            () => TextFormField(
                              initialValue:
                                  controller.massVolume.value.toString(),
                              decoration: _buildInputDecoration('Масса/объем'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => controller.updateMassVolume(
                                double.tryParse(value) ?? 0.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: Obx(
                            () => DropdownButtonFormField<Unit>(
                              value: controller.massVolumeUnit,
                              decoration:
                                  _buildInputDecoration('Единица измерения'),
                              items: Unit.values.map((Unit unit) {
                                return DropdownMenuItem<Unit>(
                                  value: unit,
                                  child: Text(
                                    switch (unit) {
                                      Unit.grams => "Граммы",
                                      Unit.kilograms => "Килограммы",
                                      Unit.milliliters => "Миллилитры",
                                      Unit.liters => "Литры",
                                      Unit.pieces => "Штуки",
                                    },
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  controller.unit = value;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: _spacing),
                    Obx(
                      () => TextFormField(
                        initialValue: controller.nutritionFacts.value,
                        minLines: 3,
                        maxLines: 5,
                        decoration: _buildInputDecoration('Пищевая ценность'),
                        onChanged: (value) =>
                            controller.updateNutritionFacts(value),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save),
        label: const Text('Сохранить'),
        onPressed: () {
          if (controller.id.value == -1) {
            AppDatabase.instance.insertProduct(
              ProductCompanion.insert(
                name: controller.name.value,
                description: Value(controller.description.value),
                productType: controller.category,
                manufactureDate: controller.manufactureDate.value,
                expirationDate: controller.expirationDate.value,
                massVolume: controller.massVolume.value,
                unit: controller.unit,
                nutritionFacts: controller.nutritionFacts.value,
              ),
            );
          } else {
            AppDatabase.instance.updateProduct(ProductCompanion(
              id: Value(controller.id.value),
              name: Value(controller.name.value),
              description: Value(controller.description.value),
              productType: Value(controller.category),
              manufactureDate: Value(controller.manufactureDate.value),
              expirationDate: Value(controller.expirationDate.value),
              massVolume: Value(controller.massVolume.value),
              unit: Value(controller.unit),
              nutritionFacts: Value(controller.nutritionFacts.value),
            ));
          }
          Get.back();
        },
      ),
    );
  }
}
