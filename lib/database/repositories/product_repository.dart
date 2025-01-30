import 'package:drift/drift.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/database/models/transaction_type.dart';

class ProductRepository {
  final AppDatabase _db;

  ProductRepository(this._db);

  Future<List<ProductData>> getAllProducts() => _db.select(_db.product).get();
  
  Stream<List<ProductData>> watchAllProducts() => _db.select(_db.product).watch();

  Future<ProductData?> getProductById(int id) async {
    final query = _db.select(_db.product)..where((tbl) => tbl.id.equals(id));
    final results = await query.get();
    if (results.isEmpty) return null;
    return results.first;
  }

  Future<int> insertProduct(ProductCompanion prod) async {
    final id = await _db.into(_db.product).insert(prod);
    await _db.transactionRepository.insertProductTransaction(
      ProductTransactionCompanion(
        productName: Value(prod.name.value),
        transactionDate: Value(DateTime.now()),
        type: const Value(TransactionType.replenishment),
        quantity: Value(prod.massVolume.value.toInt()),
      ),
    );
    return id;
  }

  Future<int> deleteProduct(int id) async {
    var prod = await (_db.select(_db.product)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
    await _db.transactionRepository.insertProductTransaction(
      ProductTransactionCompanion(
        productName: Value(prod.name),
        transactionDate: Value(DateTime.now()),
        type: const Value(TransactionType.deletion),
        quantity: const Value(1),
      ),
    );
    return (_db.delete(_db.product)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<bool> updateProduct(ProductCompanion prod) async {
    final oldProduct = await (_db.select(_db.product)
          ..where((tbl) => tbl.id.equals(prod.id.value)))
        .getSingle();
    final updated = await _db.update(_db.product).replace(prod);

    if (prod.massVolume.present) {
      final quantityDiff = prod.massVolume.value - oldProduct.massVolume;
      if (quantityDiff != 0) {
        await _db.transactionRepository.insertProductTransaction(
          ProductTransactionCompanion(
            productName: Value(prod.name.value),
            transactionDate: Value(DateTime.now()),
            type: Value(quantityDiff > 0
                ? TransactionType.replenishment
                : TransactionType.expense),
            quantity: Value(quantityDiff.abs().toInt()),
          ),
        );
      }
    }
    return updated;
  }

  Future<void> deleteAllProducts() => _db.delete(_db.product).go();
}