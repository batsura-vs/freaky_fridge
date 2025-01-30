import 'package:drift/drift.dart';

class WishListItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get quantity => integer()();
  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
} 