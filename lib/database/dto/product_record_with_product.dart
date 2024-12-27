import 'package:freaky_fridge/database/database.dart';

class ProductRecordWithProduct {
  final ProductRecordData record;
  final ProductData product;

  ProductRecordWithProduct({required this.record, required this.product});
}