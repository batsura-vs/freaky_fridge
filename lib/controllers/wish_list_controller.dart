import 'package:drift/drift.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;

class WishListController extends GetxController {
  final wishList = <WishListItemData>[].obs;
  final quantity = 0.obs;
  final searchQuery = ''.obs;

  List<WishListItemData> get sortedWishList {
    final uncheckedItems = wishList.where((item) => !item.isChecked).toList();
    final checkedItems = wishList.where((item) => item.isChecked).toList();
    return [...uncheckedItems, ...checkedItems];
  }

  @override
  void onInit() {
    super.onInit();
    _loadWishList();
  }

  void _loadWishList() {
    AppDatabase.instance.wishListRepository
        .watchAllWishListItems()
        .listen((items) {
      wishList.value = items;
    });
  }

  Future<void> addToWishList(String productName, int quantity) async {
    final existingItem = await AppDatabase.instance.wishListRepository
        .getWishListItemByProductName(productName);

    if (existingItem != null) {
      await updateQuantity(productName, existingItem.quantity + quantity);
    } else {
      await AppDatabase.instance.wishListRepository.insertWishListItem(
        WishListItemCompanion.insert(
          productName: productName,
          quantity: quantity,
          isChecked: const Value(false),
        ),
      );
    }
  }

  Future<void> removeFromWishList(String productName) async {
    final item = await AppDatabase.instance.wishListRepository
        .getWishListItemByProductName(productName);
    if (item != null) {
      await AppDatabase.instance.wishListRepository.deleteWishListItem(item.id);
    }
  }

  Future<void> updateQuantity(String productName, int newQuantity) async {
    final item = await AppDatabase.instance.wishListRepository
        .getWishListItemByProductName(productName);
    if (item != null) {
      await AppDatabase.instance.wishListRepository.updateWishListItem(
        WishListItemCompanion(
          id: Value(item.id),
          productName: Value(productName),
          quantity: Value(newQuantity),
          isChecked: Value(item.isChecked),
        ),
      );
    }
  }

  Future<void> toggleItemChecked(int id) async {
    final items = await AppDatabase.instance.wishListRepository.getAllWishListItems();
    final item = items.firstWhere((item) => item.id == id);
    await AppDatabase.instance.wishListRepository.updateWishListItem(
      WishListItemCompanion(
        id: Value(item.id),
        productName: Value(item.productName),
        quantity: Value(item.quantity),
        isChecked: Value(!item.isChecked),
      ),
    );
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
