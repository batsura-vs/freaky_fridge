import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;

class ProductRecordController extends GetxController {
  var id = (-1).obs;
  var productId = 0.obs;
  var amount = 0.obs;
  var expiration = DateTime.now().obs;

  void updateProduct(ProductRecordData newProduct) {
    id.value = newProduct.id;
    productId.value = newProduct.productId;
    amount.value = newProduct.amount;
    expiration.value = newProduct.expiration;
  }

  void updateAmount(int amount) {
    this.amount.value = amount;
  }

  void updateExpiration(DateTime expiration) {
    this.expiration.value = expiration;
  }

  void updateProductId(int productId) {
    this.productId.value = productId;
  }
}
