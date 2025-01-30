import 'package:freaky_fridge/database/database.dart';

class WishListRepository {
  final AppDatabase _db;

  WishListRepository(this._db);

  Future<List<WishListItemData>> getAllWishListItems() async {
    return await (_db.select(_db.wishListItem)).get();
  }

  Future<int> insertWishListItem(WishListItemCompanion item) async {
    return await _db.into(_db.wishListItem).insert(item);
  }

  Future<bool> updateWishListItem(WishListItemCompanion item) async {
    return await (_db.update(_db.wishListItem)
          ..where((tbl) => tbl.id.equals(item.id.value)))
        .write(item) >
        0;
  }

  Future<int> deleteWishListItem(int id) async {
    return await (_db.delete(_db.wishListItem)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<void> deleteAllWishListItems() async {
    await _db.delete(_db.wishListItem).go();
  }

  Stream<List<WishListItemData>> watchAllWishListItems() {
    return (_db.select(_db.wishListItem)).watch();
  }

  Future<WishListItemData?> getWishListItemByProductId(int productId) async {
    final query = _db.select(_db.wishListItem)
      ..where((tbl) => tbl.productId.equals(productId));
    final results = await query.get();
    if (results.isEmpty) return null;
    return results.first;
  }
} 