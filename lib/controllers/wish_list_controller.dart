import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart';

class WishListRecord {
  final ProductData product;
  int quantity;

  WishListRecord({required this.product, required this.quantity});
}

class WishListController extends GetxController {
  RxList<WishListRecord> wishList = RxList.empty();
  var searchQuery = ''.obs;
  var quantity = 0.obs;

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void addToWishList(
    ProductData product,
    int amount,
  ) {
    final existingRecord = wishList.firstWhereOrNull(
      (record) => record.product.id == product.id,
    );
    if (existingRecord != null) {
      existingRecord.quantity += amount;
      wishList.refresh();
    } else {
      wishList.add(
        WishListRecord(
          product: product,
          quantity: amount,
        ),
      );
    }
  }

  void removeFromWishList(ProductData product) {
    wishList.removeWhere((record) => record.product.id == product.id);
  }

  void clearWishList() {
    wishList.clear();
  }

  void updateQuantity(ProductData product, int quantity) {
    final existingRecord = wishList.firstWhereOrNull(
      (record) => record.product.id == product.id,
    );
    if (existingRecord != null) {
      existingRecord.quantity = quantity;
      wishList.refresh();
    }
    wishList.refresh();
  }
}
