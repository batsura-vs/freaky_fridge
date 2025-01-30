import 'package:freaky_fridge/database/database.dart';
import 'package:drift/drift.dart';

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

  Future<WishListItemData?> getWishListItemByProductName(
      String productName) async {
    final query = _db.select(_db.wishListItem)
      ..where((tbl) => tbl.productName.equals(productName));
    final results = await query.get();
    if (results.isEmpty) return null;
    return results.first;
  }

  Future<bool> toggleItemChecked(int id) async {
    final item = await (_db.select(_db.wishListItem)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingle();
    await (_db.update(_db.wishListItem)..where((tbl) => tbl.id.equals(id)))
        .write(WishListItemCompanion(isChecked: Value(!item.isChecked)));
    return !item.isChecked;
  }
}
