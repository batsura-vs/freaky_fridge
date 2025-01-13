import 'package:drift/drift.dart';

class Product extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get productType => text()();
  DateTimeColumn get manufactureDate => dateTime()();
  DateTimeColumn get expirationDate => dateTime()();
  RealColumn get massVolume => real()();
  TextColumn get unit => text()();
  TextColumn get nutritionFacts => text()();
  TextColumn get measurementType => text()();
}
