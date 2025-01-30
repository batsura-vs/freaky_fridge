// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoryTable extends Category
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
  @override
  List<GeneratedColumn> get $columns => [id, name];
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
  const CategoryData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CategoryCompanion toCompanion(bool nullToAbsent) {
    return CategoryCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory CategoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  CategoryData copyWith({int? id, String? name}) => CategoryData(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  CategoryData copyWithCompanion(CategoryCompanion data) {
    return CategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData && other.id == this.id && other.name == this.name);
}

class CategoryCompanion extends UpdateCompanion<CategoryData> {
  final Value<int> id;
  final Value<String> name;
  const CategoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  CategoryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<CategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  CategoryCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return CategoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
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
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        productType,
        manufactureDate,
        expirationDate,
        massVolume,
        unit,
        nutritionFacts
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
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
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
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
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
  final String? description;
  final int productType;
  final DateTime manufactureDate;
  final DateTime expirationDate;
  final double massVolume;
  final Unit unit;
  final String nutritionFacts;
  const ProductData(
      {required this.id,
      required this.name,
      this.description,
      required this.productType,
      required this.manufactureDate,
      required this.expirationDate,
      required this.massVolume,
      required this.unit,
      required this.nutritionFacts});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['product_type'] = Variable<int>(productType);
    map['manufacture_date'] = Variable<DateTime>(manufactureDate);
    map['expiration_date'] = Variable<DateTime>(expirationDate);
    map['mass_volume'] = Variable<double>(massVolume);
    {
      map['unit'] = Variable<int>($ProductTable.$converterunit.toSql(unit));
    }
    map['nutrition_facts'] = Variable<String>(nutritionFacts);
    return map;
  }

  ProductCompanion toCompanion(bool nullToAbsent) {
    return ProductCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      productType: Value(productType),
      manufactureDate: Value(manufactureDate),
      expirationDate: Value(expirationDate),
      massVolume: Value(massVolume),
      unit: Value(unit),
      nutritionFacts: Value(nutritionFacts),
    );
  }

  factory ProductData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      productType: serializer.fromJson<int>(json['productType']),
      manufactureDate: serializer.fromJson<DateTime>(json['manufactureDate']),
      expirationDate: serializer.fromJson<DateTime>(json['expirationDate']),
      massVolume: serializer.fromJson<double>(json['massVolume']),
      unit: $ProductTable.$converterunit
          .fromJson(serializer.fromJson<int>(json['unit'])),
      nutritionFacts: serializer.fromJson<String>(json['nutritionFacts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'productType': serializer.toJson<int>(productType),
      'manufactureDate': serializer.toJson<DateTime>(manufactureDate),
      'expirationDate': serializer.toJson<DateTime>(expirationDate),
      'massVolume': serializer.toJson<double>(massVolume),
      'unit': serializer.toJson<int>($ProductTable.$converterunit.toJson(unit)),
      'nutritionFacts': serializer.toJson<String>(nutritionFacts),
    };
  }

  ProductData copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          int? productType,
          DateTime? manufactureDate,
          DateTime? expirationDate,
          double? massVolume,
          Unit? unit,
          String? nutritionFacts}) =>
      ProductData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        productType: productType ?? this.productType,
        manufactureDate: manufactureDate ?? this.manufactureDate,
        expirationDate: expirationDate ?? this.expirationDate,
        massVolume: massVolume ?? this.massVolume,
        unit: unit ?? this.unit,
        nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      );
  ProductData copyWithCompanion(ProductCompanion data) {
    return ProductData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('productType: $productType, ')
          ..write('manufactureDate: $manufactureDate, ')
          ..write('expirationDate: $expirationDate, ')
          ..write('massVolume: $massVolume, ')
          ..write('unit: $unit, ')
          ..write('nutritionFacts: $nutritionFacts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, productType,
      manufactureDate, expirationDate, massVolume, unit, nutritionFacts);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.productType == this.productType &&
          other.manufactureDate == this.manufactureDate &&
          other.expirationDate == this.expirationDate &&
          other.massVolume == this.massVolume &&
          other.unit == this.unit &&
          other.nutritionFacts == this.nutritionFacts);
}

class ProductCompanion extends UpdateCompanion<ProductData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> productType;
  final Value<DateTime> manufactureDate;
  final Value<DateTime> expirationDate;
  final Value<double> massVolume;
  final Value<Unit> unit;
  final Value<String> nutritionFacts;
  const ProductCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.productType = const Value.absent(),
    this.manufactureDate = const Value.absent(),
    this.expirationDate = const Value.absent(),
    this.massVolume = const Value.absent(),
    this.unit = const Value.absent(),
    this.nutritionFacts = const Value.absent(),
  });
  ProductCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required int productType,
    required DateTime manufactureDate,
    required DateTime expirationDate,
    required double massVolume,
    required Unit unit,
    required String nutritionFacts,
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
    Expression<String>? description,
    Expression<int>? productType,
    Expression<DateTime>? manufactureDate,
    Expression<DateTime>? expirationDate,
    Expression<double>? massVolume,
    Expression<int>? unit,
    Expression<String>? nutritionFacts,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (productType != null) 'product_type': productType,
      if (manufactureDate != null) 'manufacture_date': manufactureDate,
      if (expirationDate != null) 'expiration_date': expirationDate,
      if (massVolume != null) 'mass_volume': massVolume,
      if (unit != null) 'unit': unit,
      if (nutritionFacts != null) 'nutrition_facts': nutritionFacts,
    });
  }

  ProductCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? productType,
      Value<DateTime>? manufactureDate,
      Value<DateTime>? expirationDate,
      Value<double>? massVolume,
      Value<Unit>? unit,
      Value<String>? nutritionFacts}) {
    return ProductCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      productType: productType ?? this.productType,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expirationDate: expirationDate ?? this.expirationDate,
      massVolume: massVolume ?? this.massVolume,
      unit: unit ?? this.unit,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('productType: $productType, ')
          ..write('manufactureDate: $manufactureDate, ')
          ..write('expirationDate: $expirationDate, ')
          ..write('massVolume: $massVolume, ')
          ..write('unit: $unit, ')
          ..write('nutritionFacts: $nutritionFacts')
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
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>(
              $ProductTransactionTable.$convertertype);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productName, transactionDate, quantity, type];
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
    context.handle(_typeMeta, const VerificationResult.success());
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
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      type: $ProductTransactionTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
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
  final DateTime transactionDate;
  final int quantity;
  final TransactionType type;
  const ProductTransactionData(
      {required this.id,
      required this.productName,
      required this.transactionDate,
      required this.quantity,
      required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_name'] = Variable<String>(productName);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['quantity'] = Variable<int>(quantity);
    {
      map['type'] =
          Variable<String>($ProductTransactionTable.$convertertype.toSql(type));
    }
    return map;
  }

  ProductTransactionCompanion toCompanion(bool nullToAbsent) {
    return ProductTransactionCompanion(
      id: Value(id),
      productName: Value(productName),
      transactionDate: Value(transactionDate),
      quantity: Value(quantity),
      type: Value(type),
    );
  }

  factory ProductTransactionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductTransactionData(
      id: serializer.fromJson<int>(json['id']),
      productName: serializer.fromJson<String>(json['productName']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      quantity: serializer.fromJson<int>(json['quantity']),
      type: $ProductTransactionTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productName': serializer.toJson<String>(productName),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'quantity': serializer.toJson<int>(quantity),
      'type': serializer
          .toJson<String>($ProductTransactionTable.$convertertype.toJson(type)),
    };
  }

  ProductTransactionData copyWith(
          {int? id,
          String? productName,
          DateTime? transactionDate,
          int? quantity,
          TransactionType? type}) =>
      ProductTransactionData(
        id: id ?? this.id,
        productName: productName ?? this.productName,
        transactionDate: transactionDate ?? this.transactionDate,
        quantity: quantity ?? this.quantity,
        type: type ?? this.type,
      );
  ProductTransactionData copyWithCompanion(ProductTransactionCompanion data) {
    return ProductTransactionData(
      id: data.id.present ? data.id.value : this.id,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductTransactionData(')
          ..write('id: $id, ')
          ..write('productName: $productName, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('quantity: $quantity, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productName, transactionDate, quantity, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductTransactionData &&
          other.id == this.id &&
          other.productName == this.productName &&
          other.transactionDate == this.transactionDate &&
          other.quantity == this.quantity &&
          other.type == this.type);
}

class ProductTransactionCompanion
    extends UpdateCompanion<ProductTransactionData> {
  final Value<int> id;
  final Value<String> productName;
  final Value<DateTime> transactionDate;
  final Value<int> quantity;
  final Value<TransactionType> type;
  const ProductTransactionCompanion({
    this.id = const Value.absent(),
    this.productName = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.quantity = const Value.absent(),
    this.type = const Value.absent(),
  });
  ProductTransactionCompanion.insert({
    this.id = const Value.absent(),
    required String productName,
    required DateTime transactionDate,
    required int quantity,
    required TransactionType type,
  })  : productName = Value(productName),
        transactionDate = Value(transactionDate),
        quantity = Value(quantity),
        type = Value(type);
  static Insertable<ProductTransactionData> custom({
    Expression<int>? id,
    Expression<String>? productName,
    Expression<DateTime>? transactionDate,
    Expression<int>? quantity,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productName != null) 'product_name': productName,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (quantity != null) 'quantity': quantity,
      if (type != null) 'type': type,
    });
  }

  ProductTransactionCompanion copyWith(
      {Value<int>? id,
      Value<String>? productName,
      Value<DateTime>? transactionDate,
      Value<int>? quantity,
      Value<TransactionType>? type}) {
    return ProductTransactionCompanion(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      transactionDate: transactionDate ?? this.transactionDate,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
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
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
          $ProductTransactionTable.$convertertype.toSql(type.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductTransactionCompanion(')
          ..write('id: $id, ')
          ..write('productName: $productName, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('quantity: $quantity, ')
          ..write('type: $type')
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [category, product, productTransaction];
}

typedef $$CategoryTableCreateCompanionBuilder = CategoryCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$CategoryTableUpdateCompanionBuilder = CategoryCompanion Function({
  Value<int> id,
  Value<String> name,
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
          }) =>
              CategoryCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              CategoryCompanion.insert(
            id: id,
            name: name,
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
  Value<String?> description,
  required int productType,
  required DateTime manufactureDate,
  required DateTime expirationDate,
  required double massVolume,
  required Unit unit,
  required String nutritionFacts,
});
typedef $$ProductTableUpdateCompanionBuilder = ProductCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<int> productType,
  Value<DateTime> manufactureDate,
  Value<DateTime> expirationDate,
  Value<double> massVolume,
  Value<Unit> unit,
  Value<String> nutritionFacts,
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

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

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
    PrefetchHooks Function({bool productType})> {
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
            Value<String?> description = const Value.absent(),
            Value<int> productType = const Value.absent(),
            Value<DateTime> manufactureDate = const Value.absent(),
            Value<DateTime> expirationDate = const Value.absent(),
            Value<double> massVolume = const Value.absent(),
            Value<Unit> unit = const Value.absent(),
            Value<String> nutritionFacts = const Value.absent(),
          }) =>
              ProductCompanion(
            id: id,
            name: name,
            description: description,
            productType: productType,
            manufactureDate: manufactureDate,
            expirationDate: expirationDate,
            massVolume: massVolume,
            unit: unit,
            nutritionFacts: nutritionFacts,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            required int productType,
            required DateTime manufactureDate,
            required DateTime expirationDate,
            required double massVolume,
            required Unit unit,
            required String nutritionFacts,
          }) =>
              ProductCompanion.insert(
            id: id,
            name: name,
            description: description,
            productType: productType,
            manufactureDate: manufactureDate,
            expirationDate: expirationDate,
            massVolume: massVolume,
            unit: unit,
            nutritionFacts: nutritionFacts,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({productType = false}) {
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
                return [];
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
    PrefetchHooks Function({bool productType})>;
typedef $$ProductTransactionTableCreateCompanionBuilder
    = ProductTransactionCompanion Function({
  Value<int> id,
  required String productName,
  required DateTime transactionDate,
  required int quantity,
  required TransactionType type,
});
typedef $$ProductTransactionTableUpdateCompanionBuilder
    = ProductTransactionCompanion Function({
  Value<int> id,
  Value<String> productName,
  Value<DateTime> transactionDate,
  Value<int> quantity,
  Value<TransactionType> type,
});

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

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));
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

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
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
    (
      ProductTransactionData,
      BaseReferences<_$AppDatabase, $ProductTransactionTable,
          ProductTransactionData>
    ),
    ProductTransactionData,
    PrefetchHooks Function()> {
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
            Value<DateTime> transactionDate = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<TransactionType> type = const Value.absent(),
          }) =>
              ProductTransactionCompanion(
            id: id,
            productName: productName,
            transactionDate: transactionDate,
            quantity: quantity,
            type: type,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String productName,
            required DateTime transactionDate,
            required int quantity,
            required TransactionType type,
          }) =>
              ProductTransactionCompanion.insert(
            id: id,
            productName: productName,
            transactionDate: transactionDate,
            quantity: quantity,
            type: type,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
    (
      ProductTransactionData,
      BaseReferences<_$AppDatabase, $ProductTransactionTable,
          ProductTransactionData>
    ),
    ProductTransactionData,
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
}
