import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/services/expiration_service.dart';

class ProductController extends GetxController {
  final expirationService = Get.put(ExpirationService());
  final id = (-1).obs;
  final name = ''.obs;
  final categoryId = (-1).obs;
  final manufactureDate = DateTime.now().obs;
  final expirationDate = DateTime.now().add(const Duration(days: 7)).obs;
  final massVolume = 0.0.obs;
  final unitValue = Unit.grams.obs;
  final nutritionFacts = ''.obs;
  final allergens = <Map<String, String>>[].obs;
  final categoryName = ''.obs;
  final isDetectingAllergens = false.obs;
  final isAnalyzingImage = false.obs;

  void updateProduct(ProductData product) {
    id.value = product.id;
    name.value = product.name;
    categoryId.value = product.productType;
    manufactureDate.value = product.manufactureDate;
    expirationDate.value = product.expirationDate;
    massVolume.value = product.massVolume;
    unitValue.value = Unit.values[product.unit.index];
    nutritionFacts.value = product.nutritionFacts;

    // Update allergens from JSON
    try {
      final List<dynamic> decodedAllergens = jsonDecode(product.allergens);
      allergens.value =
          decodedAllergens.map((e) => Map<String, String>.from(e)).toList();
    } catch (e) {
      allergens.value = [];
    }

    // Schedule notification for the updated product
    expirationService.scheduleProductNotification(product);
  }

  void updateName(String value) => name.value = value;
  void updateCategory(int value) => categoryId.value = value;
  void updateManufactureDate(DateTime value) => manufactureDate.value = value;
  void updateExpirationDate(DateTime value) => expirationDate.value = value;
  void updateMassVolume(double value) => massVolume.value = value;
  void updateUnit(Unit value) => unitValue.value = value;
  void updateNutritionFacts(String value) => nutritionFacts.value = value;

  // Allergen-related methods
  void updateAllergens(List<Map<String, String>> value) =>
      allergens.value = value;
  void removeAllergen(String allergenName) {
    allergens.removeWhere((allergen) => allergen['name'] == allergenName);
  }

  Future<void> save() async {
    final product = ProductCompanion(
      id: id.value == -1 ? const Value.absent() : Value(id.value),
      name: Value(name.value),
      productType: Value(categoryId.value),
      manufactureDate: Value(manufactureDate.value),
      expirationDate: Value(expirationDate.value),
      massVolume: Value(massVolume.value),
      unit: Value(unitValue.value),
      nutritionFacts: Value(nutritionFacts.value),
      allergens: Value(jsonEncode(allergens)),
    );

    if (id.value == -1) {
      id.value = await AppDatabase.instance.insertProduct(product);
    } else {
      await AppDatabase.instance.updateProduct(product);
    }
  }

  int get category => categoryId.value;
  Unit get unit => unitValue.value;

  void updateUnitFromString(String unitName) {
    unitValue.value = Unit.values.firstWhere(
      (u) => u.toString().split('.').last == unitName,
      orElse: () => Unit.grams,
    );
  }

  int get unitAsInt => unitValue.value.index;
  void updateUnitFromInt(int index) => unitValue.value = Unit.values[index];

  void updateCategoryName(String name) {
    categoryName.value = name;
  }
}
