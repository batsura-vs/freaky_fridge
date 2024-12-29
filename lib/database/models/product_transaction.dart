import 'package:drift/drift.dart';
import 'product.dart';
import 'transaction_type.dart';

class ProductTransaction extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Product, #id)();
  DateTimeColumn get transactionDate => dateTime()();
  IntColumn get quantity => integer()();
  TextColumn get type => textEnum<TransactionType>()();
}