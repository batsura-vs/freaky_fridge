import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:freaky_fridge/database/repositories/category_repository.dart';
import 'package:freaky_fridge/database/repositories/product_repository.dart';
import 'package:freaky_fridge/database/repositories/transaction_repository.dart';
import 'package:freaky_fridge/database/models/category.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/database/models/product_transaction.dart';
import 'package:freaky_fridge/database/models/transaction_type.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Product, Category, ProductTransaction],
)
class AppDatabase extends _$AppDatabase {
  // Singleton instance
  static final AppDatabase _instance = AppDatabase._internal();
  static AppDatabase get instance => _instance;

  // Repositories
  late final CategoryRepository categoryRepository;
  late final ProductRepository productRepository;
  late final TransactionRepository transactionRepository;

  AppDatabase._internal() : super(_openConnection()) {
    categoryRepository = CategoryRepository(this);
    productRepository = ProductRepository(this);
    transactionRepository = TransactionRepository(this);
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      return driftDatabase(name: 'productdb');
    });
  }

  @override
  int get schemaVersion => 1;

  // Delegate methods to repositories
  Future<List<CategoryData>> getAllCategories() =>
      categoryRepository.getAllCategories();
  Future<CategoryData> getCategoryById(int id) =>
      categoryRepository.getCategoryById(id);
  Future<CategoryData?> getCategoryByName(String name) =>
      categoryRepository.getCategoryByName(name);
  Future<int> insertCategory(CategoryCompanion category) =>
      categoryRepository.insertCategory(category);

  Future<List<ProductData>> get allProducts =>
      productRepository.getAllProducts();
  Stream<List<ProductData>> watchAllProducts() =>
      productRepository.watchAllProducts();
  Future<int> insertProduct(ProductCompanion prod) =>
      productRepository.insertProduct(prod);
  Future<int> deleteProduct(int id) => productRepository.deleteProduct(id);
  Future<bool> updateProduct(ProductCompanion prod) =>
      productRepository.updateProduct(prod);

  Future<List<ProductTransactionData>> get allProductTransactions =>
      transactionRepository.getAllProductTransactions();
  Future<int> insertProductTransaction(ProductTransactionCompanion record) =>
      transactionRepository.insertProductTransaction(record);
  Future<int> deleteProductTransaction(int id) =>
      transactionRepository.deleteProductTransaction(id);
  Future<bool> updateProductTransaction(ProductTransactionCompanion record) =>
      transactionRepository.updateProductTransaction(record);
  Stream<List<ProductTransactionData>> watchAllProductTransactions() =>
      transactionRepository.watchAllProductTransactions();
  Future<Map<DateTime, Map<String, dynamic>>> getProductTransactionsForPeriod(
          DateTime startDate, DateTime endDate) =>
      transactionRepository.getProductTransactionsForPeriod(startDate, endDate);
}
