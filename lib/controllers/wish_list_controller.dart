import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart';

class WishListRecord {
  final ProductData product;
  int quantity;

  WishListRecord({required this.product, required this.quantity});
}

class WishListController extends GetxController {
  final AppDatabase _db = AppDatabase.instance;
  RxList<WishListRecord> wishList = RxList.empty();
  var searchQuery = ''.obs;
  var quantity = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadWishList();
  }

  Future<void> _loadWishList() async {
    final wishListItems = await _db.wishListRepository.getAllWishListItems();
    wishList.clear();
    
    for (final item in wishListItems) {
      final product = await _db.productRepository.getProductById(item.productId);
      if (product != null) {
        wishList.add(
          WishListRecord(
            product: product,
            quantity: item.quantity,
          ),
        );
      }
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> addToWishList(
    ProductData product,
    int amount,
  ) async {
    final existingRecord = wishList.firstWhereOrNull(
      (record) => record.product.id == product.id,
    );
    
    if (existingRecord != null) {
      existingRecord.quantity += amount;
      wishList.refresh();
      
      final dbItem = await _db.wishListRepository.getWishListItemByProductId(product.id);
      if (dbItem != null) {
        await _db.wishListRepository.updateWishListItem(
          WishListItemCompanion(
            id: Value(dbItem.id),
            productId: Value(product.id),
            quantity: Value(existingRecord.quantity),
          ),
        );
      }
    } else {
      wishList.add(
        WishListRecord(
          product: product,
          quantity: amount,
        ),
      );
      
      await _db.wishListRepository.insertWishListItem(
        WishListItemCompanion.insert(
          productId: product.id,
          quantity: amount,
        ),
      );
    }
  }

  Future<void> removeFromWishList(ProductData product) async {
    wishList.removeWhere((record) => record.product.id == product.id);
    
    final dbItem = await _db.wishListRepository.getWishListItemByProductId(product.id);
    if (dbItem != null) {
      await _db.wishListRepository.deleteWishListItem(dbItem.id);
    }
  }

  Future<void> clearWishList() async {
    wishList.clear();
    await _db.wishListRepository.deleteAllWishListItems();
  }

  Future<void> updateQuantity(ProductData product, int quantity) async {
    final existingRecord = wishList.firstWhereOrNull(
      (record) => record.product.id == product.id,
    );
    
    if (existingRecord != null) {
      existingRecord.quantity = quantity;
      wishList.refresh();
      
      final dbItem = await _db.wishListRepository.getWishListItemByProductId(product.id);
      if (dbItem != null) {
        await _db.wishListRepository.updateWishListItem(
          WishListItemCompanion(
            id: Value(dbItem.id),
            productId: Value(product.id),
            quantity: Value(quantity),
          ),
        );
      }
    }
  }
}
