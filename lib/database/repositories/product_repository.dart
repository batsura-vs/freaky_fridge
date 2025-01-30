import 'package:drift/drift.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/database/models/transaction_type.dart';

class ProductRepository {
  final AppDatabase _db;

  ProductRepository(this._db);

  Future<List<ProductData>> getAllProducts() => _db.select(_db.product).get();

  Stream<List<ProductData>> watchAllProducts() =>
      _db.select(_db.product).watch();

  Future<ProductData?> getProductById(int id) async {
    final query = _db.select(_db.product)..where((tbl) => tbl.id.equals(id));
    final results = await query.get();
    if (results.isEmpty) return null;
    return results.first;
  }

  Future<int> insertProduct(ProductCompanion prod) async {
    final id = await _db.into(_db.product).insert(prod);

    // Create initial transaction
    await _db.transactionRepository.insertProductTransaction(
      ProductTransactionCompanion(
        productName: Value(prod.name.value),
        transactionDate: Value(DateTime.now()),
        type: const Value(TransactionType.replenishment),
      ),
      productId: id,
      unit: prod.unit.value,
      quantity: prod.massVolume.value,
    );

    return id;
  }

  Future<bool> updateProduct(ProductCompanion prod) async {
    if (!prod.id.present) return false;

    final oldProduct = await getProductById(prod.id.value);
    if (oldProduct == null) return false;

    final updated = await (_db.update(_db.product)
          ..where((t) => t.id.equals(prod.id.value)))
        .write(prod);

    if (updated > 0 && prod.massVolume.present) {
      final quantityDiff = prod.massVolume.value - oldProduct.massVolume;
      if (quantityDiff != 0) {
        await _db.transactionRepository.insertProductTransaction(
          ProductTransactionCompanion(
            productName: Value(prod.name.value),
            transactionDate: Value(DateTime.now()),
            type: Value(quantityDiff > 0
                ? TransactionType.replenishment
                : TransactionType.expense),
          ),
          productId: prod.id.value,
          unit: prod.unit.value,
          quantity: quantityDiff.abs(),
        );
      }
    }
    return updated > 0;
  }

  Future<int> deleteProduct(int id) async {
    final product = await getProductById(id);
    if (product == null) return 0;

    // Create deletion transaction before deleting the product
    await _db.transactionRepository.insertProductTransaction(
      ProductTransactionCompanion(
        productName: Value(product.name),
        transactionDate: Value(DateTime.now()),
        type: const Value(TransactionType.deletion),
      ),
      productId: id,
      unit: product.unit,
      quantity: product.massVolume,
    );

    return await (_db.delete(_db.product)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllProducts() => _db.delete(_db.product).go();
}
