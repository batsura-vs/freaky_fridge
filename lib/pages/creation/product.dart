import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/product_controller.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/pages/category_list.dart';
import 'package:freaky_fridge/services/allergen_service.dart';
import 'package:freaky_fridge/services/openai_service.dart';
import 'package:get/get.dart' hide Value;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drift/drift.dart' hide JsonKey, Column;

class ProductPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  final allergenService = AllergenService(
    database: AppDatabase.instance,
    openAIService: OpenAIService(),
  );
  final openAIService = OpenAIService();
  final _imagePicker = ImagePicker();
  static const double _padding = 16.0;
  static const double _spacing = 20.0;

  // Add text editing controllers
  final _nameController = TextEditingController();
  final _massVolumeController = TextEditingController();
  final _nutritionFactsController = TextEditingController();

  ProductPage({super.key, ProductData? product}) {
    if (product != null) {
      controller.updateProduct(product);
    }
    // Initialize text controllers with current values
    _nameController.text = controller.name.value;
    _massVolumeController.text = controller.massVolume.value.toString();
    _nutritionFactsController.text = controller.nutritionFacts.value;
  }

  Future<void> _detectAllergens({String? description}) async {
    if (controller.name.value.isEmpty) {
      Get.snackbar(
        'Ошибка',
        'Заполните название продукта',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    controller.isDetectingAllergens.value = true;
    try {
      final allergens = await allergenService.detectAndSaveAllergens(
        controller.id.value,
        controller.name.value,
        description ?? '',
      );
      controller.updateAllergens(allergens);

      Get.snackbar(
        'Успешно',
        'Аллергены определены',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Ошибка',
        'Не удалось определить аллергены: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      controller.isDetectingAllergens.value = false;
    }
  }

  Future<void> _analyzeImage() async {
    try {
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.camera);
      if (image == null) return;

      controller.isAnalyzingImage.value = true;

      // Convert image to base64
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Analyze image
      final productInfo = await openAIService.analyzeProductImage(base64Image);

      // Update controller with extracted information
      controller.updateName(productInfo['name'] ?? '');
      controller.updateMassVolume(productInfo['massVolume'] ?? 0.0);
      controller.updateUnitFromString(productInfo['unit'] ?? 'grams');
      _nameController.text = productInfo['name'] ?? '';
      _massVolumeController.text = (productInfo['massVolume'] ?? 0).toString();
      // controller.updateNutritionFacts(productInfo['description'] ?? '');

      // Handle category
      if (productInfo['category'] != null &&
          productInfo['category'].isNotEmpty) {
        // First try to find existing category
        final existingCategory = await AppDatabase.instance
            .getCategoryByName(productInfo['category']);

        if (existingCategory != null) {
          // Use existing category
          controller.updateCategory(existingCategory.id);
        } else {
          // Create new category with default color
          final categoryId = await AppDatabase.instance.insertCategory(
            CategoryCompanion(
              name: Value(productInfo['category']),
              color: const Value(0xFF9C27B0), // Default purple color
            ),
          );
          controller.updateCategory(categoryId);
        }
      }

      // Set expiration date based on days
      if (productInfo['expirationDays'] != null) {
        final expirationDate = DateTime.now().add(
          Duration(days: productInfo['expirationDays']),
        );
        controller.updateExpirationDate(expirationDate);
      }

      // Detect allergens
      await _detectAllergens(description: productInfo['description']);

      Get.snackbar(
        'Успешно',
        'Продукт проанализирован',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Ошибка',
        'Не удалось проанализировать изображение: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      controller.isAnalyzingImage.value = false;
    }
  }

  InputDecoration _buildInputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffixIcon,
    );
  }

  MaterialColor _getAllergenColor(String importance) {
    return switch (importance.toLowerCase()) {
      'high' => Colors.red,
      'medium' => Colors.orange,
      _ => Colors.yellow,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _getAppBar(context),
              _getAllergens(context),
            ],
          ),
          _imageSpinner(context),
        ],
      ),
    );
  }

  Obx _imageSpinner(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isAnalyzingImage.value,
        child: Container(
          color: Colors.black.withAlpha((255 * 0.5).toInt()),
          child: Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          ),
                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Анализируем фотографию...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Определяем название, состав\nи другие характеристики продукта',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _getAllergens(BuildContext context) {
    return SliverToBoxAdapter(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: _spacing),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('Название'),
                onChanged: (value) => controller.updateName(value),
              ),
              const SizedBox(height: _spacing),
              // Allergens section
              _buildAllergenTitleAndControlls(),
              const SizedBox(height: 8),
              _buildAllergenChips(),
              const SizedBox(height: _spacing),
              _buildCategorySelection(),
              const SizedBox(height: _spacing),
              _buildManufactureDate(context),
              const SizedBox(height: _spacing),
              _buildUnitSelection(),
              const SizedBox(height: _spacing),
              TextFormField(
                controller: _nutritionFactsController,
                minLines: 3,
                maxLines: 5,
                decoration: _buildInputDecoration('Дополнительная информация'),
                onChanged: (value) => controller.updateNutritionFacts(value),
              ),
              const SizedBox(height: _spacing * 2),
              FilledButton(
                onPressed: () async {
                  if (controller.name.value.isEmpty) {
                    Get.snackbar(
                      'Ошибка',
                      'Заполните название продукта',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  await controller.save();
                  Get.back();
                },
                child: const Text('Сохранить'),
              ),
              const SizedBox(height: _spacing),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildAllergenTitleAndControlls() {
    return Row(
      children: [
        const Text(
          'Аллергены',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Obx(
          () => TextButton.icon(
            onPressed:
                controller.isDetectingAllergens.value ? null : _detectAllergens,
            icon: controller.isDetectingAllergens.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.refresh),
            label: Text(
              controller.isDetectingAllergens.value
                  ? 'Определение...'
                  : 'Определить',
            ),
          ),
        ),
      ],
    );
  }

  Obx _buildAllergenChips() {
    return Obx(() {
      if (controller.allergens.isEmpty) {
        return const Text(
          'Нет обнаруженных аллергенов',
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        );
      }
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.allergens.map((allergen) {
          final color = _getAllergenColor(allergen['importance'] ?? 'low');
          return Chip(
            label: Text(
              allergen['name'] ?? '',
              style: TextStyle(
                color: color.shade700,
                fontSize: 12,
              ),
            ),
            backgroundColor: color.withAlpha((255 * 0.2).toInt()),
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: () async {
              if (controller.id.value != -1) {
                await allergenService.removeAllergenFromProduct(
                  controller.id.value,
                  allergen['name'] ?? '',
                );
              }
              controller.removeAllergen(allergen['name'] ?? '');
            },
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        }).toList(),
      );
    });
  }

  Row _buildUnitSelection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: _massVolumeController,
            decoration: _buildInputDecoration('Масса/объем'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              controller.updateMassVolume(double.tryParse(value) ?? 0);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(
            () => DropdownButtonFormField<Unit>(
              value: controller.unit,
              decoration: _buildInputDecoration('Ед.'),
              items: Unit.values.map((unit) {
                return DropdownMenuItem<Unit>(
                  value: unit,
                  child: Text(
                    switch (unit) {
                      Unit.grams => 'г',
                      Unit.kilograms => 'кг',
                      Unit.milliliters => 'мл',
                      Unit.liters => 'л',
                      Unit.pieces => 'шт',
                    },
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.updateUnit(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Row _buildManufactureDate(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Дата производства'),
              const SizedBox(height: 8),
              Obx(() => OutlinedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: controller.manufactureDate.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        controller.updateManufactureDate(date);
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      DateFormat('dd.MM.yyyy')
                          .format(controller.manufactureDate.value),
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Срок годности'),
              const SizedBox(height: 8),
              Obx(() => OutlinedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: controller.expirationDate.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        controller.updateExpirationDate(date);
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      DateFormat('dd.MM.yyyy')
                          .format(controller.expirationDate.value),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  StreamBuilder<List<CategoryData>> _buildCategorySelection() {
    return StreamBuilder<List<CategoryData>>(
      stream:
          AppDatabase.instance.select(AppDatabase.instance.category).watch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final categories = snapshot.data!;
        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: categories
                        .firstWhereOrNull(
                            (category) => category.id == controller.category)
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
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Get.to(() => CategoryListScreen()),
              tooltip: 'Редактировать категории',
            ),
          ],
        );
      },
    );
  }

  SliverAppBar _getAppBar(BuildContext context) {
    return SliverAppBar.large(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      title: Text(
        controller.id.value == -1 ? "Новый продукт" : "Редактировать продукт",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: _analyzeImage,
        ),
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
    );
  }
}
