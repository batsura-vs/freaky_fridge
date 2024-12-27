import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart';

class ProductRecordController extends GetxController {
  var record = ProductRecordCompanion.insert(
    id: const Value(-1),
    productId: 0,
    amount: 0,
    expiration: DateTime.now(),
  ).obs;

  void updateProduct(ProductRecordData newProduct) {
    record.value = ProductRecordCompanion.insert(
      id: Value(newProduct.id),
      productId: newProduct.productId,
      amount: newProduct.amount,
      expiration: newProduct.expiration,
    );
  }

  void updateAmount(int amount) {
    record.value = ProductRecordCompanion.insert(
      id: Value(record.value.id.value),
      productId: record.value.productId.value,
      amount: amount,
      expiration: record.value.expiration.value,
    );
  }

  void updateExpiration(DateTime expiration) {
    record.value = ProductRecordCompanion.insert(
      id: Value(record.value.id.value),
      productId: record.value.productId.value,
      amount: record.value.amount.value,
      expiration: expiration,
    );
  }

  void updateProductId(int productId) {
    record.value = ProductRecordCompanion.insert(
      id: Value(record.value.id.value),
      productId: productId,
      amount: record.value.amount.value,
      expiration: record.value.expiration.value,
    );
  }
}
