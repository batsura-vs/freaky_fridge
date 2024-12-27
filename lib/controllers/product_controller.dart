import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart';

class ProductController extends GetxController {
  var product = ProductCompanion.insert(
    id: const Value(-1),
    name: '',
    description: const Value(null),
  ).obs;

  void updateProduct(ProductData newProduct) {
    product.value = ProductCompanion.insert(
      id: Value(newProduct.id),
      name: newProduct.name,
      description: Value(newProduct.description),
    );
  }

  void updateName(String name) {
    product.value = ProductCompanion.insert(
      id: Value(product.value.id.value),
      name: name,
      description: Value(product.value.description.value),
    );
  }

    void updateDescription(String description) {
    product.value = ProductCompanion.insert(
      id: Value(product.value.id.value),
      name: product.value.name.value,
      description: Value(description),
    );
  }
}