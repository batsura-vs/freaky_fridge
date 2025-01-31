// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoryTable extends app_models.Category
    with TableInfo<$CategoryTable, CategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF9C27B0));
  @override
  List<GeneratedColumn> get $columns => [id, name, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
    );
  }

  @override
  $CategoryTable createAlias(String alias) {
    return $CategoryTable(attachedDatabase, alias);
  }
}

class CategoryData extends DataClass implements Insertable<CategoryData> {
  final int id;
  final String name;
  final int color;
  const CategoryData(
      {required this.id, required this.name, required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    return map;
  }

  CategoryCompanion toCompanion(bool nullToAbsent) {
    return CategoryCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
    );
  }

  factory CategoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
    };
  }

  CategoryData copyWith({int? id, String? name, int? color}) => CategoryData(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
      );
  CategoryData copyWithCompanion(CategoryCompanion data) {
    return CategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class CategoryCompanion extends UpdateCompanion<CategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  const CategoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  CategoryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  CategoryCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? color}) {
    return CategoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $ProductTable extends Product with TableInfo<$ProductTable, ProductData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productTypeMeta =
      const VerificationMeta('productType');
  @override
  late final GeneratedColumn<int> productType = GeneratedColumn<int>(
      'product_type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES category (id)'));
  static const VerificationMeta _manufactureDateMeta =
      const VerificationMeta('manufactureDate');
  @override
  late final GeneratedColumn<DateTime> manufactureDate =
      GeneratedColumn<DateTime>('manufacture_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expirationDateMeta =
      const VerificationMeta('expirationDate');
  @override
  late final GeneratedColumn<DateTime> expirationDate =
      GeneratedColumn<DateTime>('expiration_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _massVolumeMeta =
      const VerificationMeta('massVolume');
  @override
  late final GeneratedColumn<double> massVolume = GeneratedColumn<double>(
      'mass_volume', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumnWithTypeConverter<Unit, int> unit =
      GeneratedColumn<int>('unit', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Unit>($ProductTable.$converterunit);
  static const VerificationMeta _nutritionFactsMeta =
      const VerificationMeta('nutritionFacts');
  @override
  late final GeneratedColumn<String> nutritionFacts = GeneratedColumn<String>(
      'nutrition_facts', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _allergensMeta =
      const VerificationMeta('allergens');
  @override
  late final GeneratedColumn<String> allergens = GeneratedColumn<String>(
      'allergens', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        productType,
        manufactureDate,
        expirationDate,
        massVolume,
        unit,
        nutritionFacts,
        allergens
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product';
  @override
  VerificationContext validateIntegrity(Insertable<ProductData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('product_type')) {
      context.handle(
          _productTypeMeta,
          productType.isAcceptableOrUnknown(
              data['product_type']!, _productTypeMeta));
    } else if (isInserting) {
      context.missing(_productTypeMeta);
    }
    if (data.containsKey('manufacture_date')) {
      context.handle(
          _manufactureDateMeta,
          manufactureDate.isAcceptableOrUnknown(
              data['manufacture_date']!, _manufactureDateMeta));
    } else if (isInserting) {
      context.missing(_manufactureDateMeta);
    }
    if (data.containsKey('expiration_date')) {
      context.handle(
          _expirationDateMeta,
          expirationDate.isAcceptableOrUnknown(
              data['expiration_date']!, _expirationDateMeta));
    } else if (isInserting) {
      context.missing(_expirationDateMeta);
    }
    if (data.containsKey('mass_volume')) {
      context.handle(
          _massVolumeMeta,
          massVolume.isAcceptableOrUnknown(
              data['mass_volume']!, _massVolumeMeta));
    } else if (isInserting) {
      context.missing(_massVolumeMeta);
    }
    context.handle(_unitMeta, const VerificationResult.success());
    if (data.containsKey('nutrition_facts')) {
      context.handle(
          _nutritionFactsMeta,
          nutritionFacts.isAcceptableOrUnknown(
              data['nutrition_facts']!, _nutritionFactsMeta));
    } else if (isInserting) {
      context.missing(_nutritionFactsMeta);
    }
    if (data.containsKey('allergens')) {
      context.handle(_allergensMeta,
          allergens.isAcceptableOrUnknown(data['allergens']!, _allergensMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      productType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_type'])!,
      manufactureDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}manufacture_date'])!,
      expirationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}expiration_date'])!,
      massVolume: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mass_volume'])!,
      unit: $ProductTable.$converterunit.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit'])!),
      nutritionFacts: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nutrition_facts'])!,
      allergens: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}allergens'])!,
    );
  }

  @override
  $ProductTable createAlias(String alias) {
    return $ProductTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Unit, int, int> $converterunit =
      const EnumIndexConverter<Unit>(Unit.values);
}

class ProductData extends DataClass implements Insertable<ProductData> {
  final int id;
  final String name;
  final int productType;
  final DateTime manufactureDate;
  final DateTime expirationDate;
  final double massVolume;
  final Unit unit;
  final String nutritionFacts;
  final String allergens;
  const ProductData(
      {required this.id,
      required this.name,
      required this.productType,
      required this.manufactureDate,
      required this.expirationDate,
      required this.massVolume,
      required this.unit,
      required this.nutritionFacts,
      required this.allergens});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['product_type'] = Variable<int>(productType);
    map['manufacture_date'] = Variable<DateTime>(manufactureDate);
    map['expiration_date'] = Variable<DateTime>(expirationDate);
    map['mass_volume'] = Variable<double>(massVolume);
    {
      map['unit'] = Variable<int>($ProductTable.$converterunit.toSql(unit));
    }
    map['nutrition_facts'] = Variable<String>(nutritionFacts);
    map['allergens'] = Variable<String>(allergens);
    return map;
  }

  ProductCompanion toCompanion(bool nullToAbsent) {
    return ProductCompanion(
      id: Value(id),
      name: Value(name),
      productType: Value(productType),
      manufactureDate: Value(manufactureDate),
      expirationDate: Value(expirationDate),
      massVolume: Value(massVolume),
      unit: Value(unit),
      nutritionFacts: Value(nutritionFacts),
      allergens: Value(allergens),
    );
  }

  factory ProductData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      productType: serializer.fromJson<int>(json['productType']),
      manufactureDate: serializer.fromJson<DateTime>(json['manufactureDate']),
      expirationDate: serializer.fromJson<DateTime>(json['expirationDate']),
      massVolume: serializer.fromJson<double>(json['massVolume']),
      unit: $ProductTable.$converterunit
          .fromJson(serializer.fromJson<int>(json['unit'])),
      nutritionFacts: serializer.fromJson<String>(json['nutritionFacts']),
      allergens: serializer.fromJson<String>(json['allergens']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'productType': serializer.toJson<int>(productType),
      'manufactureDate': serializer.toJson<DateTime>(manufactureDate),
      'expirationDate': serializer.toJson<DateTime>(expirationDate),
      'massVolume': serializer.toJson<double>(massVolume),
      'unit': serializer.toJson<int>($ProductTable.$converterunit.toJson(unit)),
      'nutritionFacts': serializer.toJson<String>(nutritionFacts),
      'allergens': serializer.toJson<String>(allergens),
    };
  }

  ProductData copyWith(
          {int? id,
          String? name,
          int? productType,
          DateTime? manufactureDate,
          DateTime? expirationDate,
          double? massVolume,
          Unit? unit,
          String? nutritionFacts,
          String? allergens}) =>
      ProductData(
        id: id ?? this.id,
        name: name ?? this.name,
        productType: productType ?? this.productType,
        manufactureDate: manufactureDate ?? this.manufactureDate,
        expirationDate: expirationDate ?? this.expirationDate,
        massVolume: massVolume ?? this.massVolume,
        unit: unit ?? this.unit,
        nutritionFacts: nutritionFacts ?? this.nutritionFacts,
        allergens: allergens ?? this.allergens,
      );
  ProductData copyWithCompanion(ProductCompanion data) {
    return ProductData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      productType:
          data.productType.present ? data.productType.value : this.productType,
      manufactureDate: data.manufactureDate.present
          ? data.manufactureDate.value
          : this.manufactureDate,
      expirationDate: data.expirationDate.present
          ? data.expirationDate.value
          : this.expirationDate,
      massVolume:
          data.massVolume.present ? data.massVolume.value : this.massVolume,
      unit: data.unit.present ? data.unit.value : this.unit,
      nutritionFacts: data.nutritionFacts.present
          ? data.nutritionFacts.value
          : this.nutritionFacts,
      allergens: data.allergens.present ? data.allergens.value : this.allergens,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('productType: $productType, ')
          ..write('manufactureDate: $manufactureDate, ')
          ..write('expirationDate: $expirationDate, ')
          ..write('massVolume: $massVolume, ')
          ..write('unit: $unit, ')
          ..write('nutritionFacts: $nutritionFacts, ')
          ..write('allergens: $allergens')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, productType, manufactureDate,
      expirationDate, massVolume, unit, nutritionFacts, allergens);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductData &&
          other.id == this.id &&
          other.name == this.name &&
          other.productType == this.productType &&
          other.manufactureDate == this.manufactureDate &&
          other.expirationDate == this.expirationDate &&
          other.massVolume == this.massVolume &&
          other.unit == this.unit &&
          other.nutritionFacts == this.nutritionFacts &&
          other.allergens == this.allergens);
}

class ProductCompanion extends UpdateCompanion<ProductData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> productType;
  final Value<DateTime> manufactureDate;
  final Value<DateTime> expirationDate;
  final Value<double> massVolume;
  final Value<Unit> unit;
  final Value<String> nutritionFacts;
  final Value<String> allergens;
  const ProductCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.productType = const Value.absent(),
    this.manufactureDate = const Value.absent(),
    this.expirationDate = const Value.absent(),
    this.massVolume = const Value.absent(),
    this.unit = const Value.absent(),
    this.nutritionFacts = const Value.absent(),
    this.allergens = const Value.absent(),
  });
  ProductCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int productType,
    required DateTime manufactureDate,
    required DateTime expirationDate,
    required double massVolume,
    required Unit unit,
    required String nutritionFacts,
    this.allergens = const Value.absent(),
  })  : name = Value(name),
        productType = Value(productType),
        manufactureDate = Value(manufactureDate),
        expirationDate = Value(expirationDate),
        massVolume = Value(massVolume),
        unit = Value(unit),
        nutritionFacts = Value(nutritionFacts);
  static Insertable<ProductData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? productType,
    Expression<DateTime>? manufactureDate,
    Expression<DateTime>? expirationDate,
    Expression<double>? massVolume,
    Expression<int>? unit,
    Expression<String>? nutritionFacts,
    Expression<String>? allergens,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (productType != null) 'product_type': productType,
      if (manufactureDate != null) 'manufacture_date': manufactureDate,
      if (expirationDate != null) 'expiration_date': expirationDate,
      if (massVolume != null) 'mass_volume': massVolume,
      if (unit != null) 'unit': unit,
      if (nutritionFacts != null) 'nutrition_facts': nutritionFacts,
      if (allergens != null) 'allergens': allergens,
    });
  }

  ProductCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? productType,
      Value<DateTime>? manufactureDate,
      Value<DateTime>? expirationDate,
      Value<double>? massVolume,
      Value<Unit>? unit,
      Value<String>? nutritionFacts,
      Value<String>? allergens}) {
    return ProductCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      productType: productType ?? this.productType,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expirationDate: expirationDate ?? this.expirationDate,
      massVolume: massVolume ?? this.massVolume,
      unit: unit ?? this.unit,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      allergens: allergens ?? this.allergens,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (productType.present) {
      map['product_type'] = Variable<int>(productType.value);
    }
    if (manufactureDate.present) {
      map['manufacture_date'] = Variable<DateTime>(manufactureDate.value);
    }
    if (expirationDate.present) {
      map['expiration_date'] = Variable<DateTime>(expirationDate.value);
    }
    if (massVolume.present) {
      map['mass_volume'] = Variable<double>(massVolume.value);
    }
    if (unit.present) {
      map['unit'] =
          Variable<int>($ProductTable.$converterunit.toSql(unit.value));
    }
    if (nutritionFacts.present) {
      map['nutrition_facts'] = Variable<String>(nutritionFacts.value);
    }
    if (allergens.present) {
      map['allergens'] = Variable<String>(allergens.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('productType: $productType, ')
          ..write('manufactureDate: $manufactureDate, ')
          ..write('expirationDate: $expirationDate, ')
          ..write('massVolume: $massVolume, ')
          ..write('unit: $unit, ')
          ..write('nutritionFacts: $nutritionFacts, ')
          ..write('allergens: $allergens')
          ..write(')'))
        .toString();
  }
}

class $ProductTransactionTable extends ProductTransaction
    with TableInfo<$ProductTransactionTable, ProductTransactionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductTransactionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<int> unit = GeneratedColumn<int>(
      'unit', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _normalizedQuantityMeta =
      const VerificationMeta('normalizedQuantity');
  @override
  late final GeneratedColumn<double> normalizedQuantity =
      GeneratedColumn<double>('normalized_quantity', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>(
              $ProductTransactionTable.$convertertype);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES product (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productName,
        categoryName,
        transactionDate,
        quantity,
        unit,
        normalizedQuantity,
        type,
        productId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_transaction';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProductTransactionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('normalized_quantity')) {
      context.handle(
          _normalizedQuantityMeta,
          normalizedQuantity.isAcceptableOrUnknown(
              data['normalized_quantity']!, _normalizedQuantityMeta));
    } else if (isInserting) {
      context.missing(_normalizedQuantityMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductTransactionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductTransactionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit'])!,
      normalizedQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}normalized_quantity'])!,
      type: $ProductTransactionTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id']),
    );
  }

  @override
  $ProductTransactionTable createAlias(String alias) {
    return $ProductTransactionTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
}

class ProductTransactionData extends DataClass
    implements Insertable<ProductTransactionData> {
  final int id;
  final String productName;
  final String categoryName;
  final DateTime transactionDate;
  final double quantity;
  final int unit;
  final double normalizedQuantity;
  final TransactionType type;
  final int? productId;
  const ProductTransactionData(
      {required this.id,
      required this.productName,
      required this.categoryName,
      required this.transactionDate,
      required this.quantity,
      required this.unit,
      required this.normalizedQuantity,
      required this.type,
      this.productId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_name'] = Variable<String>(productName);
    map['category_name'] = Variable<String>(categoryName);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<int>(unit);
    map['normalized_quantity'] = Variable<double>(normalizedQuantity);
    {
      map['type'] =
          Variable<String>($ProductTransactionTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    return map;
  }

  ProductTransactionCompanion toCompanion(bool nullToAbsent) {
    return ProductTransactionCompanion(
      id: Value(id),
      productName: Value(productName),
      categoryName: Value(categoryName),
      transactionDate: Value(transactionDate),
      quantity: Value(quantity),
      unit: Value(unit),
      normalizedQuantity: Value(normalizedQuantity),
      type: Value(type),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
    );
  }

  factory ProductTransactionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductTransactionData(
      id: serializer.fromJson<int>(json['id']),
      productName: serializer.fromJson<String>(json['productName']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<int>(json['unit']),
      normalizedQuantity:
          serializer.fromJson<double>(json['normalizedQuantity']),
      type: $ProductTransactionTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      productId: serializer.fromJson<int?>(json['productId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productName': serializer.toJson<String>(productName),
      'categoryName': serializer.toJson<String>(categoryName),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<int>(unit),
      'normalizedQuantity': serializer.toJson<double>(normalizedQuantity),
      'type': serializer
          .toJson<String>($ProductTransactionTable.$convertertype.toJson(type)),
      'productId': serializer.toJson<int?>(productId),
    };
  }

  ProductTransactionData copyWith(
          {int? id,
          String? productName,
          String? categoryName,
          DateTime? transactionDate,
          double? quantity,
          int? unit,
          double? normalizedQuantity,
          TransactionType? type,
          Value<int?> productId = const Value.absent()}) =>
      ProductTransactionData(
        id: id ?? this.id,
        productName: productName ?? this.productName,
        categoryName: categoryName ?? this.categoryName,
        transactionDate: transactionDate ?? this.transactionDate,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        normalizedQuantity: normalizedQuantity ?? this.normalizedQuantity,
        type: type ?? this.type,
        productId: productId.present ? productId.value : this.productId,
      );
  ProductTransactionData copyWithCompanion(ProductTransactionCompanion data) {
    return ProductTransactionData(
      id: data.id.present ? data.id.value : this.id,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      normalizedQuantity: data.normalizedQuantity.present
          ? data.normalizedQuantity.value
          : this.normalizedQuantity,
      type: data.type.present ? data.type.value : this.type,
      productId: data.productId.present ? data.productId.value : this.productId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductTransactionData(')
          ..write('id: $id, ')
          ..write('productName: $productName, ')
          ..write('categoryName: $categoryName, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('normalizedQuantity: $normalizedQuantity, ')
          ..write('type: $type, ')
          ..write('productId: $productId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productName, categoryName,
      transactionDate, quantity, unit, normalizedQuantity, type, productId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductTransactionData &&
          other.id == this.id &&
          other.productName == this.productName &&
          other.categoryName == this.categoryName &&
          other.transactionDate == this.transactionDate &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.normalizedQuantity == this.normalizedQuantity &&
          other.type == this.type &&
          other.productId == this.productId);
}

class ProductTransactionCompanion
    extends UpdateCompanion<ProductTransactionData> {
  final Value<int> id;
  final Value<String> productName;
  final Value<String> categoryName;
  final Value<DateTime> transactionDate;
  final Value<double> quantity;
  final Value<int> unit;
  final Value<double> normalizedQuantity;
  final Value<TransactionType> type;
  final Value<int?> productId;
  const ProductTransactionCompanion({
    this.id = const Value.absent(),
    this.productName = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.normalizedQuantity = const Value.absent(),
    this.type = const Value.absent(),
    this.productId = const Value.absent(),
  });
  ProductTransactionCompanion.insert({
    this.id = const Value.absent(),
    required String productName,
    required String categoryName,
    required DateTime transactionDate,
    required double quantity,
    required int unit,
    required double normalizedQuantity,
    required TransactionType type,
    this.productId = const Value.absent(),
  })  : productName = Value(productName),
        categoryName = Value(categoryName),
        transactionDate = Value(transactionDate),
        quantity = Value(quantity),
        unit = Value(unit),
        normalizedQuantity = Value(normalizedQuantity),
        type = Value(type);
  static Insertable<ProductTransactionData> custom({
    Expression<int>? id,
    Expression<String>? productName,
    Expression<String>? categoryName,
    Expression<DateTime>? transactionDate,
    Expression<double>? quantity,
    Expression<int>? unit,
    Expression<double>? normalizedQuantity,
    Expression<String>? type,
    Expression<int>? productId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productName != null) 'product_name': productName,
      if (categoryName != null) 'category_name': categoryName,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (normalizedQuantity != null) 'normalized_quantity': normalizedQuantity,
      if (type != null) 'type': type,
      if (productId != null) 'product_id': productId,
    });
  }

  ProductTransactionCompanion copyWith(
      {Value<int>? id,
      Value<String>? productName,
      Value<String>? categoryName,
      Value<DateTime>? transactionDate,
      Value<double>? quantity,
      Value<int>? unit,
      Value<double>? normalizedQuantity,
      Value<TransactionType>? type,
      Value<int?>? productId}) {
    return ProductTransactionCompanion(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      categoryName: categoryName ?? this.categoryName,
      transactionDate: transactionDate ?? this.transactionDate,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      normalizedQuantity: normalizedQuantity ?? this.normalizedQuantity,
      type: type ?? this.type,
      productId: productId ?? this.productId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<int>(unit.value);
    }
    if (normalizedQuantity.present) {
      map['normalized_quantity'] = Variable<double>(normalizedQuantity.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
          $ProductTransactionTable.$convertertype.toSql(type.value));
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductTransactionCompanion(')
          ..write('id: $id, ')
          ..write('productName: $productName, ')
          ..write('categoryName: $categoryName, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('normalizedQuantity: $normalizedQuantity, ')
          ..write('type: $type, ')
          ..write('productId: $productId')
          ..write(')'))
        .toString();
  }
}

class $WishListItemTable extends WishListItem
    with TableInfo<$WishListItemTable, WishListItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WishListItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isCheckedMeta =
      const VerificationMeta('isChecked');
  @override
  late final GeneratedColumn<bool> isChecked = GeneratedColumn<bool>(
      'is_checked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_checked" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, productName, quantity, isChecked];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wish_list_item';
  @override
  VerificationContext validateIntegrity(Insertable<WishListItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('is_checked')) {
      context.handle(_isCheckedMeta,
          isChecked.isAcceptableOrUnknown(data['is_checked']!, _isCheckedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WishListItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WishListItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      isChecked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_checked'])!,
    );
  }

  @override
  $WishListItemTable createAlias(String alias) {
    return $WishListItemTable(attachedDatabase, alias);
  }
}

class WishListItemData extends DataClass
    implements Insertable<WishListItemData> {
  final int id;
  final String productName;
  final int quantity;
  final bool isChecked;
  const WishListItemData(
      {required this.id,
      required this.productName,
      required this.quantity,
      required this.isChecked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<int>(quantity);
    map['is_checked'] = Variable<bool>(isChecked);
    return map;
  }

  WishListItemCompanion toCompanion(bool nullToAbsent) {
    return WishListItemCompanion(
      id: Value(id),
      productName: Value(productName),
      quantity: Value(quantity),
      isChecked: Value(isChecked),
    );
  }

  factory WishListItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WishListItemData(
      id: serializer.fromJson<int>(json['id']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      isChecked: serializer.fromJson<bool>(json['isChecked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<int>(quantity),
      'isChecked': serializer.toJson<bool>(isChecked),
    };
  }

  WishListItemData copyWith(
          {int? id, String? productName, int? quantity, bool? isChecked}) =>
      WishListItemData(
        id: id ?? this.id,
        productName: productName ?? this.productName,
        quantity: quantity ?? this.quantity,
        isChecked: isChecked ?? this.isChecked,
      );
  WishListItemData copyWithCompanion(WishListItemCompanion data) {
    return WishListItemData(
      id: data.id.present ? data.id.value : this.id,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      isChecked: data.isChecked.present ? data.isChecked.value : this.isChecked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WishListItemData(')
          ..write('id: $id, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('isChecked: $isChecked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productName, quantity, isChecked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishListItemData &&
          other.id == this.id &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.isChecked == this.isChecked);
}

class WishListItemCompanion extends UpdateCompanion<WishListItemData> {
  final Value<int> id;
  final Value<String> productName;
  final Value<int> quantity;
  final Value<bool> isChecked;
  const WishListItemCompanion({
    this.id = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.isChecked = const Value.absent(),
  });
  WishListItemCompanion.insert({
    this.id = const Value.absent(),
    required String productName,
    required int quantity,
    this.isChecked = const Value.absent(),
  })  : productName = Value(productName),
        quantity = Value(quantity);
  static Insertable<WishListItemData> custom({
    Expression<int>? id,
    Expression<String>? productName,
    Expression<int>? quantity,
    Expression<bool>? isChecked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (isChecked != null) 'is_checked': isChecked,
    });
  }

  WishListItemCompanion copyWith(
      {Value<int>? id,
      Value<String>? productName,
      Value<int>? quantity,
      Value<bool>? isChecked}) {
    return WishListItemCompanion(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (isChecked.present) {
      map['is_checked'] = Variable<bool>(isChecked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WishListItemCompanion(')
          ..write('id: $id, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('isChecked: $isChecked')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoryTable category = $CategoryTable(this);
  late final $ProductTable product = $ProductTable(this);
  late final $ProductTransactionTable productTransaction =
      $ProductTransactionTable(this);
  late final $WishListItemTable wishListItem = $WishListItemTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [category, product, productTransaction, wishListItem];
}

typedef $$CategoryTableCreateCompanionBuilder = CategoryCompanion Function({
  Value<int> id,
  required String name,
  Value<int> color,
});
typedef $$CategoryTableUpdateCompanionBuilder = CategoryCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> color,
});

final class $$CategoryTableReferences
    extends BaseReferences<_$AppDatabase, $CategoryTable, CategoryData> {
  $$CategoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductTable, List<ProductData>>
      _productRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.product,
              aliasName:
                  $_aliasNameGenerator(db.category.id, db.product.productType));

  $$ProductTableProcessedTableManager get productRefs {
    final manager = $$ProductTableTableManager($_db, $_db.product)
        .filter((f) => f.productType.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_productRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoryTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryTable> {
  $$CategoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  Expression<bool> productRefs(
      Expression<bool> Function($$ProductTableFilterComposer f) f) {
    final $$ProductTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.product,
        getReferencedColumn: (t) => t.productType,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductTableFilterComposer(
              $db: $db,
              $table: $db.product,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoryTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryTable> {
  $$CategoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));
}

class $$CategoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryTable> {
  $$CategoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> productRefs<T extends Object>(
      Expression<T> Function($$ProductTableAnnotationComposer a) f) {
    final $$ProductTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.product,
        getReferencedColumn: (t) => t.productType,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductTableAnnotationComposer(
              $db: $db,
              $table: $db.product,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoryTable,
    CategoryData,
    $$CategoryTableFilterComposer,
    $$CategoryTableOrderingComposer,
    $$CategoryTableAnnotationComposer,
    $$CategoryTableCreateCompanionBuilder,
    $$CategoryTableUpdateCompanionBuilder,
    (CategoryData, $$CategoryTableReferences),
    CategoryData,
    PrefetchHooks Function({bool productRefs})> {
  $$CategoryTableTableManager(_$AppDatabase db, $CategoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> color = const Value.absent(),
          }) =>
              CategoryCompanion(
            id: id,
            name: name,
            color: color,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> color = const Value.absent(),
          }) =>
              CategoryCompanion.insert(
            id: id,
            name: name,
            color: color,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CategoryTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({productRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productRefs) db.product],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CategoryTableReferences._productRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoryTableReferences(db, table, p0)
                                .productRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productType == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoryTable,
    CategoryData,
    $$CategoryTableFilterComposer,
    $$CategoryTableOrderingComposer,
    $$CategoryTableAnnotationComposer,
    $$CategoryTableCreateCompanionBuilder,
    $$CategoryTableUpdateCompanionBuilder,
    (CategoryData, $$CategoryTableReferences),
    CategoryData,
    PrefetchHooks Function({bool productRefs})>;
typedef $$ProductTableCreateCompanionBuilder = ProductCompanion Function({
  Value<int> id,
  required String name,
  required int productType,
  required DateTime manufactureDate,
  required DateTime expirationDate,
  required double massVolume,
  required Unit unit,
  required String nutritionFacts,
  Value<String> allergens,
});
typedef $$ProductTableUpdateCompanionBuilder = ProductCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> productType,
  Value<DateTime> manufactureDate,
  Value<DateTime> expirationDate,
  Value<double> massVolume,
  Value<Unit> unit,
  Value<String> nutritionFacts,
  Value<String> allergens,
});

final class $$ProductTableReferences
    extends BaseReferences<_$AppDatabase, $ProductTable, ProductData> {
  $$ProductTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoryTable _productTypeTable(_$AppDatabase db) =>
      db.category.createAlias(
          $_aliasNameGenerator(db.product.productType, db.category.id));

  $$CategoryTableProcessedTableManager get productType {
    final manager = $$CategoryTableTableManager($_db, $_db.category)
        .filter((f) => f.id($_item.productType!));
    final item = $_typedResult.readTableOrNull(_productTypeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ProductTransactionTable,
      List<ProductTransactionData>> _productTransactionRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.productTransaction,
          aliasName: $_aliasNameGenerator(
              db.product.id, db.productTransaction.productId));

  $$ProductTransactionTableProcessedTableManager get productTransactionRefs {
    final manager =
        $$ProductTransactionTableTableManager($_db, $_db.productTransaction)
            .filter((f) => f.productId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_productTransactionRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductTableFilterComposer
    extends Composer<_$AppDatabase, $ProductTable> {
  $$ProductTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get manufactureDate => $composableBuilder(
      column: $table.manufactureDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expirationDate => $composableBuilder(
      column: $table.expirationDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get massVolume => $composableBuilder(
      column: $table.massVolume, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Unit, Unit, int> get unit =>
      $composableBuilder(
          column: $table.unit,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get nutritionFacts => $composableBuilder(
      column: $table.nutritionFacts,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allergens => $composableBuilder(
      column: $table.allergens, builder: (column) => ColumnFilters(column));

  $$CategoryTableFilterComposer get productType {
    final $$CategoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productType,
        referencedTable: $db.category,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryTableFilterComposer(
              $db: $db,
              $table: $db.category,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> productTransactionRefs(
      Expression<bool> Function($$ProductTransactionTableFilterComposer f) f) {
    final $$ProductTransactionTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productTransaction,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductTransactionTableFilterComposer(
              $db: $db,
              $table: $db.productTransaction,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductTable> {
  $$ProductTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get manufactureDate => $composableBuilder(
      column: $table.manufactureDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expirationDate => $composableBuilder(
      column: $table.expirationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get massVolume => $composableBuilder(
      column: $table.massVolume, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nutritionFacts => $composableBuilder(
      column: $table.nutritionFacts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allergens => $composableBuilder(
      column: $table.allergens, builder: (column) => ColumnOrderings(column));

  $$CategoryTableOrderingComposer get productType {
    final $$CategoryTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productType,
        referencedTable: $db.category,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryTableOrderingComposer(
              $db: $db,
              $table: $db.category,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductTable> {
  $$ProductTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get manufactureDate => $composableBuilder(
      column: $table.manufactureDate, builder: (column) => column);

  GeneratedColumn<DateTime> get expirationDate => $composableBuilder(
      column: $table.expirationDate, builder: (column) => column);

  GeneratedColumn<double> get massVolume => $composableBuilder(
      column: $table.massVolume, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Unit, int> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get nutritionFacts => $composableBuilder(
      column: $table.nutritionFacts, builder: (column) => column);

  GeneratedColumn<String> get allergens =>
      $composableBuilder(column: $table.allergens, builder: (column) => column);

  $$CategoryTableAnnotationComposer get productType {
    final $$CategoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productType,
        referencedTable: $db.category,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryTableAnnotationComposer(
              $db: $db,
              $table: $db.category,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> productTransactionRefs<T extends Object>(
      Expression<T> Function($$ProductTransactionTableAnnotationComposer a) f) {
    final $$ProductTransactionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.productTransaction,
            getReferencedColumn: (t) => t.productId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProductTransactionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.productTransaction,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ProductTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductTable,
    ProductData,
    $$ProductTableFilterComposer,
    $$ProductTableOrderingComposer,
    $$ProductTableAnnotationComposer,
    $$ProductTableCreateCompanionBuilder,
    $$ProductTableUpdateCompanionBuilder,
    (ProductData, $$ProductTableReferences),
    ProductData,
    PrefetchHooks Function({bool productType, bool productTransactionRefs})> {
  $$ProductTableTableManager(_$AppDatabase db, $ProductTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> productType = const Value.absent(),
            Value<DateTime> manufactureDate = const Value.absent(),
            Value<DateTime> expirationDate = const Value.absent(),
            Value<double> massVolume = const Value.absent(),
            Value<Unit> unit = const Value.absent(),
            Value<String> nutritionFacts = const Value.absent(),
            Value<String> allergens = const Value.absent(),
          }) =>
              ProductCompanion(
            id: id,
            name: name,
            productType: productType,
            manufactureDate: manufactureDate,
            expirationDate: expirationDate,
            massVolume: massVolume,
            unit: unit,
            nutritionFacts: nutritionFacts,
            allergens: allergens,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int productType,
            required DateTime manufactureDate,
            required DateTime expirationDate,
            required double massVolume,
            required Unit unit,
            required String nutritionFacts,
            Value<String> allergens = const Value.absent(),
          }) =>
              ProductCompanion.insert(
            id: id,
            name: name,
            productType: productType,
            manufactureDate: manufactureDate,
            expirationDate: expirationDate,
            massVolume: massVolume,
            unit: unit,
            nutritionFacts: nutritionFacts,
            allergens: allergens,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {productType = false, productTransactionRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productTransactionRefs) db.productTransaction
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productType) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productType,
                    referencedTable:
                        $$ProductTableReferences._productTypeTable(db),
                    referencedColumn:
                        $$ProductTableReferences._productTypeTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productTransactionRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ProductTableReferences
                            ._productTransactionRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductTableReferences(db, table, p0)
                                .productTransactionRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductTable,
    ProductData,
    $$ProductTableFilterComposer,
    $$ProductTableOrderingComposer,
    $$ProductTableAnnotationComposer,
    $$ProductTableCreateCompanionBuilder,
    $$ProductTableUpdateCompanionBuilder,
    (ProductData, $$ProductTableReferences),
    ProductData,
    PrefetchHooks Function({bool productType, bool productTransactionRefs})>;
typedef $$ProductTransactionTableCreateCompanionBuilder
    = ProductTransactionCompanion Function({
  Value<int> id,
  required String productName,
  required String categoryName,
  required DateTime transactionDate,
  required double quantity,
  required int unit,
  required double normalizedQuantity,
  required TransactionType type,
  Value<int?> productId,
});
typedef $$ProductTransactionTableUpdateCompanionBuilder
    = ProductTransactionCompanion Function({
  Value<int> id,
  Value<String> productName,
  Value<String> categoryName,
  Value<DateTime> transactionDate,
  Value<double> quantity,
  Value<int> unit,
  Value<double> normalizedQuantity,
  Value<TransactionType> type,
  Value<int?> productId,
});

final class $$ProductTransactionTableReferences extends BaseReferences<
    _$AppDatabase, $ProductTransactionTable, ProductTransactionData> {
  $$ProductTransactionTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductTable _productIdTable(_$AppDatabase db) =>
      db.product.createAlias(
          $_aliasNameGenerator(db.productTransaction.productId, db.product.id));

  $$ProductTableProcessedTableManager? get productId {
    if ($_item.productId == null) return null;
    final manager = $$ProductTableTableManager($_db, $_db.product)
        .filter((f) => f.id($_item.productId!));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProductTransactionTableFilterComposer
    extends Composer<_$AppDatabase, $ProductTransactionTable> {
  $$ProductTransactionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get normalizedQuantity => $composableBuilder(
      column: $table.normalizedQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$ProductTableFilterComposer get productId {
    final $$ProductTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.product,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductTableFilterComposer(
              $db: $db,
              $table: $db.product,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductTransactionTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductTransactionTable> {
  $$ProductTransactionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get normalizedQuantity => $composableBuilder(
      column: $table.normalizedQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  $$ProductTableOrderingComposer get productId {
    final $$ProductTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.product,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductTableOrderingComposer(
              $db: $db,
              $table: $db.product,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductTransactionTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductTransactionTable> {
  $$ProductTransactionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get normalizedQuantity => $composableBuilder(
      column: $table.normalizedQuantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  $$ProductTableAnnotationComposer get productId {
    final $$ProductTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.product,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductTableAnnotationComposer(
              $db: $db,
              $table: $db.product,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductTransactionTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductTransactionTable,
    ProductTransactionData,
    $$ProductTransactionTableFilterComposer,
    $$ProductTransactionTableOrderingComposer,
    $$ProductTransactionTableAnnotationComposer,
    $$ProductTransactionTableCreateCompanionBuilder,
    $$ProductTransactionTableUpdateCompanionBuilder,
    (ProductTransactionData, $$ProductTransactionTableReferences),
    ProductTransactionData,
    PrefetchHooks Function({bool productId})> {
  $$ProductTransactionTableTableManager(
      _$AppDatabase db, $ProductTransactionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductTransactionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductTransactionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductTransactionTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<String> categoryName = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<int> unit = const Value.absent(),
            Value<double> normalizedQuantity = const Value.absent(),
            Value<TransactionType> type = const Value.absent(),
            Value<int?> productId = const Value.absent(),
          }) =>
              ProductTransactionCompanion(
            id: id,
            productName: productName,
            categoryName: categoryName,
            transactionDate: transactionDate,
            quantity: quantity,
            unit: unit,
            normalizedQuantity: normalizedQuantity,
            type: type,
            productId: productId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String productName,
            required String categoryName,
            required DateTime transactionDate,
            required double quantity,
            required int unit,
            required double normalizedQuantity,
            required TransactionType type,
            Value<int?> productId = const Value.absent(),
          }) =>
              ProductTransactionCompanion.insert(
            id: id,
            productName: productName,
            categoryName: categoryName,
            transactionDate: transactionDate,
            quantity: quantity,
            unit: unit,
            normalizedQuantity: normalizedQuantity,
            type: type,
            productId: productId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductTransactionTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$ProductTransactionTableReferences._productIdTable(db),
                    referencedColumn: $$ProductTransactionTableReferences
                        ._productIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProductTransactionTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductTransactionTable,
    ProductTransactionData,
    $$ProductTransactionTableFilterComposer,
    $$ProductTransactionTableOrderingComposer,
    $$ProductTransactionTableAnnotationComposer,
    $$ProductTransactionTableCreateCompanionBuilder,
    $$ProductTransactionTableUpdateCompanionBuilder,
    (ProductTransactionData, $$ProductTransactionTableReferences),
    ProductTransactionData,
    PrefetchHooks Function({bool productId})>;
typedef $$WishListItemTableCreateCompanionBuilder = WishListItemCompanion
    Function({
  Value<int> id,
  required String productName,
  required int quantity,
  Value<bool> isChecked,
});
typedef $$WishListItemTableUpdateCompanionBuilder = WishListItemCompanion
    Function({
  Value<int> id,
  Value<String> productName,
  Value<int> quantity,
  Value<bool> isChecked,
});

class $$WishListItemTableFilterComposer
    extends Composer<_$AppDatabase, $WishListItemTable> {
  $$WishListItemTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isChecked => $composableBuilder(
      column: $table.isChecked, builder: (column) => ColumnFilters(column));
}

class $$WishListItemTableOrderingComposer
    extends Composer<_$AppDatabase, $WishListItemTable> {
  $$WishListItemTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isChecked => $composableBuilder(
      column: $table.isChecked, builder: (column) => ColumnOrderings(column));
}

class $$WishListItemTableAnnotationComposer
    extends Composer<_$AppDatabase, $WishListItemTable> {
  $$WishListItemTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<bool> get isChecked =>
      $composableBuilder(column: $table.isChecked, builder: (column) => column);
}

class $$WishListItemTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WishListItemTable,
    WishListItemData,
    $$WishListItemTableFilterComposer,
    $$WishListItemTableOrderingComposer,
    $$WishListItemTableAnnotationComposer,
    $$WishListItemTableCreateCompanionBuilder,
    $$WishListItemTableUpdateCompanionBuilder,
    (
      WishListItemData,
      BaseReferences<_$AppDatabase, $WishListItemTable, WishListItemData>
    ),
    WishListItemData,
    PrefetchHooks Function()> {
  $$WishListItemTableTableManager(_$AppDatabase db, $WishListItemTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WishListItemTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WishListItemTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WishListItemTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<bool> isChecked = const Value.absent(),
          }) =>
              WishListItemCompanion(
            id: id,
            productName: productName,
            quantity: quantity,
            isChecked: isChecked,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String productName,
            required int quantity,
            Value<bool> isChecked = const Value.absent(),
          }) =>
              WishListItemCompanion.insert(
            id: id,
            productName: productName,
            quantity: quantity,
            isChecked: isChecked,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WishListItemTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WishListItemTable,
    WishListItemData,
    $$WishListItemTableFilterComposer,
    $$WishListItemTableOrderingComposer,
    $$WishListItemTableAnnotationComposer,
    $$WishListItemTableCreateCompanionBuilder,
    $$WishListItemTableUpdateCompanionBuilder,
    (
      WishListItemData,
      BaseReferences<_$AppDatabase, $WishListItemTable, WishListItemData>
    ),
    WishListItemData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoryTableTableManager get category =>
      $$CategoryTableTableManager(_db, _db.category);
  $$ProductTableTableManager get product =>
      $$ProductTableTableManager(_db, _db.product);
  $$ProductTransactionTableTableManager get productTransaction =>
      $$ProductTransactionTableTableManager(_db, _db.productTransaction);
  $$WishListItemTableTableManager get wishListItem =>
      $$WishListItemTableTableManager(_db, _db.wishListItem);
}
