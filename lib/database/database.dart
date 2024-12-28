import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:freaky_fridge/database/models/category.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/database/models/product_record.dart';
import 'package:freaky_fridge/database/dto/product_record_with_product.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Product, Category, ProductRecord],
)
class ProductDatabase extends _$ProductDatabase {
  static final _instance = ProductDatabase._internal();

  ProductDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'productdb');
  }

  static ProductDatabase get instance => _instance;

  Future<List<ProductData>> get allProducts => select(product).get();

  Stream<List<ProductData>> watchAllProducts() => select(product).watch();

  Future<List<ProductRecordData>> get allProductRecords =>
      select(productRecord).get();

  Future<int> insertProduct(ProductCompanion prod) =>
      into(product).insert(prod);

  Future<void> deleteTable() => delete(product).go();

  Future<int> deleteProduct(int id) =>
      (delete(product)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> deleteProductRecord(int id) =>
      (delete(productRecord)..where((tbl) => tbl.id.equals(id))).go();

  Future<bool> updateProduct(ProductCompanion prod) =>
      update(product).replace(prod);

  Future<bool> updateProductRecord(ProductRecordCompanion record) =>
      update(productRecord).replace(record);

  Future<int> insertProductRecord(ProductRecordCompanion record) =>
      into(productRecord).insert(record);

  Stream<List<ProductRecordWithProduct>>
      watchAllProductRecordWithProduct() async* {
    final query = select(productRecord).join([
      innerJoin(product, product.id.equalsExp(productRecord.productId)),
    ]);

    yield* query.watch().map(
      (rows) {
        return rows
            .map(
              (row) => ProductRecordWithProduct(
                record: row.readTable(productRecord),
                product: row.readTable(product),
              ),
            )
            .toList();
      },
    );
  }

  Future<List<ProductRecordWithProduct>>
      getAllProductRecordWithProduct() async {
    final query = select(productRecord).join([
      innerJoin(product, product.id.equalsExp(productRecord.productId)),
    ]);

    final result = await query.get();

    return result.map((row) {
      return ProductRecordWithProduct(
        record: row.readTable(productRecord),
        product: row.readTable(product),
      );
    }).toList();
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
}
