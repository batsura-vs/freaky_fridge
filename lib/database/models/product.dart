import 'package:drift/drift.dart';

class Product extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
  IntColumn get amount => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();

  DateTimeColumn get expiration => dateTime()();
}
