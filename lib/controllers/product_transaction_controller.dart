import 'package:freaky_fridge/database/database.dart';

class ProductTransactionController {
  final AppDatabase _database = AppDatabase.instance;

  Future<List<ProductTransactionData>> getAllTransactions() async {
    return await _database.allProductTransactions;
  }

  Future<int> insertTransaction(ProductTransactionCompanion transaction) async {
    return await _database.insertProductTransaction(transaction);
  }

  Future<int> deleteTransaction(int id) async {
    return await _database.deleteProductTransaction(id);
  }

  Future<bool> updateTransaction(ProductTransactionCompanion transaction) async {
    return await _database.updateProductTransaction(transaction);
  }

  Stream<List<ProductTransactionData>> watchAllTransactions() {
    return _database.watchAllProductTransactions();
  }
}