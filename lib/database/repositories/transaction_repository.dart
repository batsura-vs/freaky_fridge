import 'package:drift/drift.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/database/dto/product_with_transaction.dart';
import 'package:freaky_fridge/database/models/transaction_type.dart';

class TransactionRepository {
  final AppDatabase _db;

  TransactionRepository(this._db);

  Future<List<ProductTransactionData>> getAllProductTransactions() =>
      _db.select(_db.productTransaction).get();

  Future<int> insertProductTransaction(ProductTransactionCompanion record) =>
      _db.into(_db.productTransaction).insert(record);

  Future<int> deleteProductTransaction(int id) =>
      (_db.delete(_db.productTransaction)..where((tbl) => tbl.id.equals(id)))
          .go();

  Future<bool> updateProductTransaction(ProductTransactionCompanion record) =>
      _db.update(_db.productTransaction).replace(record);

  Stream<List<ProductTransactionData>> watchAllProductTransactions() =>
      _db.select(_db.productTransaction).watch();

  Future<Map<DateTime, Map<String, dynamic>>> getProductTransactionsForPeriod(
      DateTime startDate, DateTime endDate) async {
    final query = _db.select(_db.productTransaction).join([
      innerJoin(_db.product,
          _db.product.name.equalsExp(_db.productTransaction.productName))
    ])
      ..where(_db.productTransaction.transactionDate
          .isBetweenValues(startDate, endDate));

    final result = await query.get();
    final groupedTransactions = <DateTime, Map<String, Map<String, dynamic>>>{};

    for (final row in result) {
      final productData = row.readTable(_db.product);
      final transactionData = row.readTable(_db.productTransaction);

      final date = transactionData.transactionDate;
      final name = productData.name;
      final type = transactionData.type;
      final quantity = transactionData.quantity;

      groupedTransactions.putIfAbsent(date, () => {});
      groupedTransactions[date]!.putIfAbsent(
          name,
          () => {
                TransactionType.replenishment.name: 0,
                TransactionType.deletion.name: 0,
                TransactionType.expense.name: 0,
              });

      groupedTransactions[date]![name]![type.name] = quantity;
    }

    return groupedTransactions;
  }

  Future<List<ProductWithTransaction>> getAllProductWithTransaction() async {
    final query = _db.select(_db.product).join([
      innerJoin(_db.productTransaction,
          _db.product.name.equalsExp(_db.productTransaction.productName)),
    ]);

    return (await query.get())
        .map(
          (row) => ProductWithTransaction(
            product: row.readTable(_db.product),
            transaction: row.readTable(_db.productTransaction),
          ),
        )
        .toList();
  }

  Stream<List<ProductWithTransaction>> watchAllProductWithTransaction() {
    final query = _db.select(_db.product).join([
      innerJoin(_db.productTransaction,
          _db.product.name.equalsExp(_db.productTransaction.productName)),
    ]);

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ProductWithTransaction(
                  product: row.readTable(_db.product),
                  transaction: row.readTable(_db.productTransaction),
                ),
              )
              .toList(),
        );
  }
}
