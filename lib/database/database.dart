import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:freaky_fridge/database/models/category.dart';
import 'package:freaky_fridge/database/models/product.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Product, Category],
)
class ProductDatabase extends _$ProductDatabase {
  ProductDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'productdb');
  }

  Future<List<ProductData>> get allProducts => select(product).get();

  Future<int> insertProduct(ProductCompanion prod) => into(product).insert(prod);

  Future<void> deleteTable() => delete(product).go();
}
