import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/database/models/product.dart';

class ProductTransactionController {
  final AppDatabase _database = AppDatabase.instance;

  Future<List<ProductTransactionData>> getAllTransactions() async {
    return await _database.allProductTransactions;
  }

  Future<int> insertTransaction(
    ProductTransactionCompanion transaction, {
    int? productId,
    required Unit unit,
    required double quantity,
  }) async {
    return await _database.insertProductTransaction(
      transaction,
      productId: productId,
      unit: unit,
      quantity: quantity,
    );
  }

  Future<int> deleteTransaction(int id) async {
    return await _database.deleteProductTransaction(id);
  }

  Future<bool> updateTransaction(
    ProductTransactionCompanion transaction, {
    required Unit unit,
    required double quantity,
  }) async {
    return await _database.updateProductTransaction(
      transaction,
      unit: unit,
      quantity: quantity,
    );
  }

  Stream<List<ProductTransactionData>> watchAllTransactions() {
    return _database.watchAllProductTransactions();
  }
}