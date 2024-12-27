import 'package:drift/drift.dart';
import 'product.dart';

class ProductRecord extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Product, #id)();
  DateTimeColumn get expiration => dateTime()();
  IntColumn get amount => integer()();
}