import 'package:freaky_fridge/database/database.dart';

class ProductWithTransaction {
  final ProductData? product;
  final ProductTransactionData transaction;

  ProductWithTransaction({
    this.product,
    required this.transaction,
  });
}