import 'package:drift/drift.dart';

class Category extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get color => integer().withDefault(const Constant(0xFF9C27B0))();  // Default purple color
}
