import 'package:drift/drift.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/database/dto/product_with_transaction.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/database/models/transaction_type.dart';

class TransactionRepository {
  final AppDatabase _db;

  TransactionRepository(this._db);

  // Convert to base unit (g, ml, or pieces)
  double _normalizeQuantity(double quantity, Unit unit) {
    switch (unit) {
      case Unit.kilograms:
        return quantity * 1000; // Convert to grams
      case Unit.liters:
        return quantity * 1000; // Convert to milliliters
      case Unit.grams:
      case Unit.milliliters:
      case Unit.pieces:
        return quantity;
    }
  }

  // Get unit type (weight, volume, or pieces)
  String _getUnitType(Unit unit) {
    switch (unit) {
      case Unit.kilograms:
      case Unit.grams:
        return 'weight';
      case Unit.liters:
      case Unit.milliliters:
        return 'volume';
      case Unit.pieces:
        return 'pieces';
    }
  }

  Future<List<ProductTransactionData>> getAllProductTransactions() =>
      _db.select(_db.productTransaction).get();

  Stream<List<ProductTransactionData>> watchAllProductTransactions() =>
      _db.select(_db.productTransaction).watch();

  Future<int> insertProductTransaction(
    ProductTransactionCompanion record, {
    int? productId,
    required Unit unit,
    required double quantity,
  }) async {
    // Get product category if product exists
    String categoryName = 'Unknown';
    if (productId != null) {
      final product = await _db.productRepository.getProductById(productId);
      if (product != null) {
        final category = await _db.categoryRepository.getCategoryById(product.productType);
        categoryName = category.name;
      }
    }

    // Calculate normalized quantity
    final normalizedQuantity = _normalizeQuantity(quantity, unit);

    // Create the insert companion with proper type conversions
    final companion = ProductTransactionCompanion.insert(
      productName: record.productName.value,
      categoryName: categoryName,
      transactionDate: record.transactionDate.value,
      type: record.type.value,
      quantity: quantity,
      unit: unit.index,
      normalizedQuantity: normalizedQuantity,
      productId: Value(productId),
    );

    return await _db.into(_db.productTransaction).insert(companion);
  }

  Future<bool> updateProductTransaction(
    ProductTransactionCompanion record, {
    required Unit unit,
    required double quantity,
  }) async {
    // Calculate normalized quantity
    final normalizedQuantity = _normalizeQuantity(quantity, unit);

    // Create the update companion with proper type conversions
    final companion = ProductTransactionCompanion(
      quantity: Value(quantity),
      unit: Value(unit.index),
      normalizedQuantity: Value(normalizedQuantity),
    );

    return await (_db.update(_db.productTransaction)
          ..where((t) => t.id.equals(record.id.value)))
        .write(companion) >
        0;
  }

  Future<int> deleteProductTransaction(int id) =>
      (_db.delete(_db.productTransaction)..where((t) => t.id.equals(id))).go();

  Future<Map<DateTime, Map<String, Map<String, dynamic>>>> getProductTransactionsForPeriod(
    DateTime startDate,
    DateTime endDate, {
    String? productName,
  }) async {
    final query = _db.select(_db.productTransaction)
      ..where((t) =>
          t.transactionDate.isBiggerOrEqualValue(startDate) &
          t.transactionDate.isSmallerOrEqualValue(endDate));
    
    if (productName != null) {
      query.where((t) => t.productName.equals(productName));
    }

    final transactions = await query.get();

    // Group by exact timestamp -> unit type -> transaction type
    final Map<DateTime, Map<String, Map<String, dynamic>>> groupedTransactions = {};

    for (var transaction in transactions) {
      final timestamp = transaction.transactionDate;

      // Convert stored unit index back to Unit enum and get its type
      final storedUnit = Unit.values[transaction.unit];
      final unitType = _getUnitType(storedUnit);

      groupedTransactions[timestamp] ??= {};
      groupedTransactions[timestamp]![unitType] ??= {
        TransactionType.replenishment.name: 0.0,
        TransactionType.deletion.name: 0.0,
        TransactionType.expense.name: 0.0,
      };

      final transactionType = transaction.type.name;
      groupedTransactions[timestamp]![unitType]![transactionType] = 
          transaction.normalizedQuantity;
    }

    return groupedTransactions;
  }

  Future<List<ProductWithTransaction>> getAllProductWithTransaction() async {
    final query = _db.select(_db.productTransaction).join([
      leftOuterJoin(
        _db.product,
        _db.product.id.equalsExp(_db.productTransaction.productId),
      ),
    ]);

    return (await query.get()).map((row) {
      final transaction = row.readTable(_db.productTransaction);
      final product = row.readTableOrNull(_db.product);
      return ProductWithTransaction(
        product: product,
        transaction: transaction,
      );
    }).toList();
  }

  Stream<List<ProductWithTransaction>> watchAllProductWithTransaction() {
    final query = _db.select(_db.productTransaction).join([
      leftOuterJoin(
        _db.product,
        _db.product.id.equalsExp(_db.productTransaction.productId),
      ),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final transaction = row.readTable(_db.productTransaction);
        final product = row.readTableOrNull(_db.product);
        return ProductWithTransaction(
          product: product,
          transaction: transaction,
        );
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getUniqueProductsWithTransactions(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final query = _db.select(_db.productTransaction, distinct: true)
      ..where((t) =>
          t.transactionDate.isBiggerOrEqualValue(startDate) &
          t.transactionDate.isSmallerOrEqualValue(endDate));

    final transactions = await query.get();
    final uniqueProducts = <String, Map<String, dynamic>>{};

    for (var transaction in transactions) {
      if (!uniqueProducts.containsKey(transaction.productName)) {
        uniqueProducts[transaction.productName] = {
          'name': transaction.productName,
          'productId': transaction.productId,
        };
      }
    }

    return uniqueProducts.values.toList();
  }
}
