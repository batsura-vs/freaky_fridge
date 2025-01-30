import 'package:drift/drift.dart';
import 'transaction_type.dart';

class ProductTransaction extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  DateTimeColumn get transactionDate => dateTime()();
  IntColumn get quantity => integer()();
  TextColumn get type => textEnum<TransactionType>()();
}
