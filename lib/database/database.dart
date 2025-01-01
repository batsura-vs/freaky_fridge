import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:freaky_fridge/database/models/category.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/database/models/product_record.dart';
import 'package:freaky_fridge/database/models/product_transaction.dart';
import 'package:freaky_fridge/database/dto/product_record_with_product.dart';
import 'package:freaky_fridge/database/dto/product_with_transaction.dart';
import 'package:freaky_fridge/database/models/transaction_type.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Product, Category, ProductRecord, ProductTransaction],
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

  // Product methods
  Future<List<ProductData>> get allProducts => select(product).get();
  Stream<List<ProductData>> watchAllProducts() => select(product).watch();
  Future<int> insertProduct(ProductCompanion prod) =>
      into(product).insert(prod);
  Future<int> deleteProduct(int id) =>
      (delete(product)..where((tbl) => tbl.id.equals(id))).go();
  Future<bool> updateProduct(ProductCompanion prod) =>
      update(product).replace(prod);
  Future<void> deleteTable() => delete(product).go();

  // ProductRecord methods
  Future<List<ProductRecordData>> get allProductRecords =>
      select(productRecord).get();
  Future<int> insertProductRecord(ProductRecordCompanion record) async {
    final id = await into(productRecord).insert(record);
    final prodRec = await getProductRecordWithProductById(id);
    if (prodRec != null) {
      await insertProductTransaction(
        ProductTransactionCompanion(
          productId: Value(prodRec.record.productId),
          transactionDate: Value(DateTime.now()),
          quantity: Value(record.amount.value),
          type: Value(TransactionType.replenishment.name),
        ),
      );
    }
    return id;
  }

  Future<int> deleteProductRecord(int id) async {
    final prodRec = await getProductRecordWithProductById(id);
    final deleted =
        await (delete(productRecord)..where((tbl) => tbl.id.equals(id))).go();
    if (prodRec != null) {
      await insertProductTransaction(
        ProductTransactionCompanion(
          productId: Value(prodRec.record.productId),
          transactionDate: Value(DateTime.now()),
          quantity: Value(prodRec.record.amount),
          type: Value(TransactionType.deletion.name),
        ),
      );
    }
    return deleted;
  }

  Future<bool> updateProductRecord(ProductRecordCompanion record) async {
    final updated = await update(productRecord).replace(record);
    final prodRec = await getProductRecordWithProductById(record.id.value);
    if (prodRec != null) {
      await insertProductTransaction(
        ProductTransactionCompanion(
          productId: Value(prodRec.record.productId),
          transactionDate: Value(DateTime.now()),
          quantity: Value(record.amount.value),
          type: Value(TransactionType.expense.name),
        ),
      );
    }
    return updated;
  }

  Stream<List<ProductRecordWithProduct>> watchAllProductRecordWithProduct() {
    final query = select(productRecord).join([
      innerJoin(product, product.id.equalsExp(productRecord.productId)),
    ]);

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ProductRecordWithProduct(
                  record: row.readTable(productRecord),
                  product: row.readTable(product),
                ),
              )
              .toList(),
        );
  }

  Future<List<ProductRecordWithProduct>>
      getAllProductRecordWithProduct() async {
    final query = select(productRecord).join([
      innerJoin(product, product.id.equalsExp(productRecord.productId)),
    ]);

    final result = await query.get();

    return result
        .map(
          (row) => ProductRecordWithProduct(
            record: row.readTable(productRecord),
            product: row.readTable(product),
          ),
        )
        .toList();
  }

  Future<ProductRecordWithProduct?> getProductRecordWithProductById(
    int id,
  ) async {
    final query = select(productRecord).join([
      innerJoin(product, product.id.equalsExp(productRecord.productId)),
    ])
      ..where(productRecord.id.equals(id));

    final result = await query.getSingleOrNull();

    if (result == null) {
      return null;
    }

    return ProductRecordWithProduct(
      record: result.readTable(productRecord),
      product: result.readTable(product),
    );
  }

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

  Future<List<ProductWithTransaction>> getProductTransactionsForPeriod(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final query = select(product).join([
      innerJoin(productTransaction,
          product.id.equalsExp(productTransaction.productId)),
    ])
      ..where(productTransaction.transactionDate
          .isBetweenValues(startDate, endDate));

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
