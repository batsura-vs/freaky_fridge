import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;
class ProductController extends GetxController {
  var id = (-1).obs;
  var name = ''.obs;
  var description = ''.obs;

  void updateProduct(ProductData newProduct) {
    id.value = newProduct.id;
    name.value = newProduct.name;
    description.value = newProduct.description ?? '';
  }

  void updateName(String name) {
    this.name.value = name;
  }

  void updateDescription(String description) {
    this.description.value = description;
  }
}