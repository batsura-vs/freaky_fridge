import 'package:drift/drift.dart';
import 'category.dart';

enum Unit {
  grams,
  kilograms,
  milliliters,
  liters,
  pieces
}

class Product extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
  IntColumn get productType => integer().references(Category, #id)();
  DateTimeColumn get manufactureDate => dateTime()();
  DateTimeColumn get expirationDate => dateTime()();
  RealColumn get massVolume => real()();
  IntColumn get unit => intEnum<Unit>()();
  TextColumn get nutritionFacts => text()();
  TextColumn get allergens => text().withDefault(const Constant('[]'))(); // Stores JSON array of allergen strings
}
