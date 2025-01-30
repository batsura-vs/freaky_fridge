import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/services/expiration_service.dart';

class ProductController extends GetxController {
  final expirationService = Get.put(ExpirationService());
  var id = (-1).obs;
  var name = ''.obs;
  var description = ''.obs;
  var categoryId = 1.obs;
  var manufactureDate = DateTime.now().obs;
  var expirationDate = DateTime.now().obs;
  var massVolume = 0.0.obs;
  var unitIndex = 0.obs;
  var massVolumeUnitIndex = 0.obs;
  var nutritionFacts = ''.obs;
  var categoryName = ''.obs;

  Unit get unit => Unit.values[unitIndex.value];
  set unit(Unit value) => unitIndex.value = value.index;

  Unit get massVolumeUnit => Unit.values[massVolumeUnitIndex.value];
  set massVolumeUnit(Unit value) => massVolumeUnitIndex.value = value.index;

  void updateProduct(ProductData newProduct) {
    id.value = newProduct.id;
    name.value = newProduct.name;
    description.value = newProduct.description ?? '';
    categoryId.value = newProduct.productType;
    manufactureDate.value = newProduct.manufactureDate;
    expirationDate.value = newProduct.expirationDate;
    massVolume.value = newProduct.massVolume;
    unit = newProduct.unit;
    massVolumeUnit = newProduct.unit;
    nutritionFacts.value = newProduct.nutritionFacts;

    // Schedule notification for the updated product
    expirationService.scheduleProductNotification(newProduct);
  }

  void updateUnitFromString(String unitName) {
    unit = Unit.values.firstWhere(
      (u) => u.toString().split('.').last == unitName,
      orElse: () => Unit.grams,
    );
  }

  int get unitAsInt => unitIndex.value;
  void updateUnitFromInt(int index) => unitIndex.value = index;

  void updateCategory(int categoryId) {
    this.categoryId.value = categoryId;
  }

  int get category => categoryId.value;

  void updateName(String name) {
    this.name.value = name;
  }

  void updateDescription(String description) {
    this.description.value = description;
  }

  void updateManufactureDate(DateTime manufactureDate) {
    this.manufactureDate.value = manufactureDate;
  }

  void updateExpirationDate(DateTime expirationDate) {
    this.expirationDate.value = expirationDate;

    // If this is an existing product, update its notification
    if (id.value != -1) {
      final product = ProductData(
        id: id.value,
        name: name.value,
        description: description.value,
        productType: categoryId.value,
        manufactureDate: manufactureDate.value,
        expirationDate: expirationDate,
        massVolume: massVolume.value,
        unit: unit,
        nutritionFacts: nutritionFacts.value,
      );
      expirationService.scheduleProductNotification(product);
    }
  }

  void updateMassVolume(double massVolume) {
    this.massVolume.value = massVolume;
  }

  void updateUnit(Unit unit) {
    this.unit = unit;
  }

  void updateNutritionFacts(String nutritionFacts) {
    this.nutritionFacts.value = nutritionFacts;
  }
}
