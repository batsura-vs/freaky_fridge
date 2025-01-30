import 'package:drift/drift.dart';
import 'product.dart';

class WishListItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Product, #id)();
  IntColumn get quantity => integer()();
} 