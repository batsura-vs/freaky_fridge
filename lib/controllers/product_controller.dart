import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;

class ProductController extends GetxController {
  var id = (-1).obs;
  var name = ''.obs;
  var description = ''.obs;
  var productType = ''.obs;
  var manufactureDate = DateTime.now().obs;
  var expirationDate = DateTime.now().obs;
  var massVolume = 0.0.obs;
  var unit = ''.obs;
  var nutritionFacts = ''.obs;
  var measurementType = ''.obs;

  void updateProduct(ProductData newProduct) {
    id.value = newProduct.id;
    name.value = newProduct.name;
    description.value = newProduct.description ?? '';
    productType.value = newProduct.productType;
    manufactureDate.value = newProduct.manufactureDate;
    expirationDate.value = newProduct.expirationDate;
    massVolume.value = newProduct.massVolume;
    unit.value = newProduct.unit;
    nutritionFacts.value = newProduct.nutritionFacts;
    measurementType.value = newProduct.measurementType;
  }

  void updateName(String name) {
    this.name.value = name;
  }

  void updateDescription(String description) {
    this.description.value = description;
  }

  void updateProductType(String productType) {
    this.productType.value = productType;
  }

  void updateManufactureDate(DateTime manufactureDate) {
    this.manufactureDate.value = manufactureDate;
  }

  void updateExpirationDate(DateTime expirationDate) {
    this.expirationDate.value = expirationDate;
  }

  void updateMassVolume(double massVolume) {
    this.massVolume.value = massVolume;
  }

  void updateUnit(String unit) {
    this.unit.value = unit;
  }

  void updateNutritionFacts(String nutritionFacts) {
    this.nutritionFacts.value = nutritionFacts;
  }

  void updateMeasurementType(String measurementType) {
    this.measurementType.value = measurementType;
  }
}