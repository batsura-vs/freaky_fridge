import 'package:freaky_fridge/database/database.dart';

class ProductWithTransaction {
  final ProductData product;
  final ProductTransactionData transaction;

  ProductWithTransaction({
    required this.product,
    required this.transaction,
  });
}