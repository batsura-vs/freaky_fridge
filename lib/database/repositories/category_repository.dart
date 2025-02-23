import 'package:freaky_fridge/database/database.dart';

class CategoryRepository {
  final AppDatabase _db;

  CategoryRepository(this._db);

  Future<int> insertCategory(CategoryCompanion category) =>
      _db.into(_db.category).insert(category);

  Future<List<CategoryData>> getAllCategories() =>
      _db.select(_db.category).get();

  Stream<List<CategoryData>> watchAllCategories() =>
      _db.select(_db.category).watch();

  Future<CategoryData> getCategoryById(int id) async {
    return await (_db.select(_db.category)..where((tbl) => tbl.id.equals(id)))
            .getSingleOrNull() ??
        const CategoryData(id: -1, name: "Default", color: 0xFF000000);
  }

  Future<CategoryData?> getCategoryByName(String name) async {
    return await (_db.select(_db.category)
          ..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
  }
}
