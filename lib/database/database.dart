import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:freaky_fridge/database/models/category.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/database/models/product_transaction.dart';
import 'package:freaky_fridge/database/dto/product_with_transaction.dart';
import 'package:freaky_fridge/database/models/transaction_type.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Product, Category, ProductTransaction],
)
class ProductDatabase extends _$ProductDatabase {
  static final ProductDatabase _instance = ProductDatabase._internal();

  ProductDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'productdb');
  }

  static ProductDatabase get instance => _instance;

  Future<int> insertCategory(CategoryCompanion category) =>
      into(this.category).insert(category);

  Future<List<CategoryData>> getAllCategories() => select(category).get();

  Future<CategoryData> getCategoryById(int id) async {
    return await (select(category)..where((tbl) => tbl.id.equals(id)))
            .getSingleOrNull() ??
        const CategoryData(id: -1, name: "Default");
  }

  Future<CategoryData?> getCategoryByName(String name) async {
    return await (select(category)..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
  }

  // Product methods
  Future<List<ProductData>> get allProducts => select(product).get();
  Stream<List<ProductData>> watchAllProducts() => select(product).watch();
  Future<int> insertProduct(ProductCompanion prod) async {
    final id = await into(product).insert(prod);
    await insertProductTransaction(ProductTransactionCompanion(
      productId: Value(id),
      transactionDate: Value(DateTime.now()),
      type: const Value(TransactionType.replenishment),
      quantity: const Value(1),
    ));
    return id;
  }

  Future<int> deleteProduct(int id) async {
    await insertProductTransaction(ProductTransactionCompanion(
      productId: Value(id),
      transactionDate: Value(DateTime.now()),
      type: const Value(TransactionType.deletion),
      quantity: const Value(1),
    ));
    return (delete(product)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<bool> updateProduct(ProductCompanion prod) async {
    final oldProduct = await (select(product)
          ..where((tbl) => tbl.id.equals(prod.id.value)))
        .getSingle();
    final updated = await update(product).replace(prod);
    if (prod.massVolume.present) {
      final quantityDiff = prod.massVolume.value - oldProduct.massVolume;
      if (quantityDiff > 0) {
        await insertProductTransaction(ProductTransactionCompanion(
          productId: Value(prod.id.value),
          transactionDate: Value(DateTime.now()),
          type: const Value(TransactionType.replenishment),
          quantity: Value(quantityDiff.toInt()),
        ));
      } else if (quantityDiff < 0) {
        await insertProductTransaction(ProductTransactionCompanion(
          productId: Value(prod.id.value),
          transactionDate: Value(DateTime.now()),
          type: const Value(TransactionType.expense),
          quantity: Value(-quantityDiff.toInt()),
        ));
      }
    }
    return updated;
  }

  Future<void> deleteTable() => delete(product).go();

  // ProductTransaction methods
  Future<List<ProductTransactionData>> get allProductTransactions =>
      select(productTransaction).get();
  Future<int> insertProductTransaction(ProductTransactionCompanion record) =>
      into(productTransaction).insert(record);
  Future<int> deleteProductTransaction(int id) =>
      (delete(productTransaction)..where((tbl) => tbl.id.equals(id))).go();
  Future<bool> updateProductTransaction(ProductTransactionCompanion record) =>
      update(productTransaction).replace(record);
  Stream<List<ProductTransactionData>> watchAllProductTransactions() =>
      select(productTransaction).watch();

  Future<Map<DateTime, Map<String, dynamic>>> getProductTransactionsForPeriod(
      DateTime startDate, DateTime endDate) async {
    final query = select(productTransaction).join([
      innerJoin(product, product.id.equalsExp(productTransaction.productId))
    ])
      ..where(productTransaction.transactionDate
          .isBetweenValues(startDate, endDate));

    final result = await query.get();

    final Map<DateTime, Map<String, Map<String, dynamic>>> groupedTransactions =
        {};

    for (final row in result) {
      final productData = row.readTable(product);
      final transactionData = row.readTable(productTransaction);

      final transactionDate = transactionData.transactionDate;
      final productName = productData.name;
      final transactionType = transactionData.type;
      final quantity = transactionData.quantity;

      if (!groupedTransactions.containsKey(transactionDate)) {
        groupedTransactions[transactionDate] = {};
      }

      if (!groupedTransactions[transactionDate]!.containsKey(productName)) {
        groupedTransactions[transactionDate]![productName] = {
          TransactionType.replenishment.name: 0,
          TransactionType.deletion.name: 0,
          TransactionType.expense.name: 0,
        };
      }

      groupedTransactions[transactionDate]![productName]![
          transactionType.name] = quantity;
    }

    return groupedTransactions;
  }

  // ProductWithTransaction methods
  Future<List<ProductWithTransaction>> getAllProductWithTransaction() async {
    final query = select(product).join([
      innerJoin(productTransaction,
          product.id.equalsExp(productTransaction.productId)),
    ]);

    final result = await query.get();

    return result
        .map(
          (row) => ProductWithTransaction(
            product: row.readTable(product),
            transaction: row.readTable(productTransaction),
          ),
        )
        .toList();
  }

  Stream<List<ProductWithTransaction>> watchAllProductWithTransaction() {
    final query = select(product).join([
      innerJoin(productTransaction,
          product.id.equalsExp(productTransaction.productId)),
    ]);

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ProductWithTransaction(
                  product: row.readTable(product),
                  transaction: row.readTable(productTransaction),
                ),
              )
              .toList(),
        );
  }
}
