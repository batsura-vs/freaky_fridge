import 'package:drift/drift.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'transaction_type.dart';

class ProductTransaction extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // Store product name separately to keep history after product deletion
  TextColumn get productName => text()();
  
  // Store category type to help with grouping and filtering
  TextColumn get categoryName => text()();
  
  DateTimeColumn get transactionDate => dateTime()();
  
  // Store original quantity and unit
  RealColumn get quantity => real()();
  IntColumn get unit => integer()();
  
  // Store normalized quantity in base unit (g, ml, or pieces)
  RealColumn get normalizedQuantity => real()();
  
  // Store transaction type
  TextColumn get type => textEnum<TransactionType>()();

  // Optional reference to product if it still exists
  IntColumn get productId => integer().nullable().references(Product, #id)();
}

// Define the companion class for drift
@DataClassName('ProductTransactionData')
class ProductTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  TextColumn get categoryName => text()();
  DateTimeColumn get transactionDate => dateTime()();
  RealColumn get quantity => real()();
  IntColumn get unit => integer()();
  RealColumn get normalizedQuantity => real()();
  TextColumn get type => textEnum<TransactionType>()();
  IntColumn get productId => integer().nullable().references(Product, #id)();
}
