import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/product_controller.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/pages/category_list.dart';
import 'package:get/get.dart' hide Value;
import 'package:intl/intl.dart';

class ProductPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  ProductPage({super.key, ProductData? product}) {
    if (product != null) {
      controller.updateProduct(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            title: Text(
              controller.id.value == -1 ? "New Product" : "Edit Product",
            ),
            actions: <Widget>[
              if (controller.id.value != -1)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    ProductDatabase.instance.deleteProduct(
                      controller.id.value,
                    );
                    Get.back();
                  },
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => TextFormField(
                        initialValue: controller.name.value,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) => controller.updateName(value),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => TextFormField(
                        initialValue: controller.description.value,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) =>
                            controller.updateDescription(value),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<List<CategoryData>>(
                        stream: ProductDatabase.instance
                            .select(ProductDatabase.instance.category)
                            .watch(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          final categories = snapshot.data!;
                          return Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: controller.category,
                                  decoration: InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  items: categories.map((category) {
                                    return DropdownMenuItem<int>(
                                      value: category.id,
                                      child: Text(category.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.updateCategory(value);
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Get.to(() => CategoryListScreen());
                                },
                              ),
                            ],
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Manufacture Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: controller.manufactureDate.value,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.updateManufactureDate(picked);
                          }
                        },
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd')
                              .format(controller.manufactureDate.value),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Expiration Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: controller.expirationDate.value,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.updateExpirationDate(picked);
                          }
                        },
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd')
                              .format(controller.expirationDate.value),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => TextFormField(
                        initialValue: controller.massVolume.value.toString(),
                        decoration: InputDecoration(
                          labelText: 'Mass/Volume',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => controller.updateMassVolume(
                          double.tryParse(value) ?? 0.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => DropdownButtonFormField<Unit>(
                        value: controller.massVolumeUnit,
                        decoration: InputDecoration(
                          labelText: 'Unit (Mass/Volume)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: Unit.values.map((Unit unit) {
                          return DropdownMenuItem<Unit>(
                            value: unit,
                            child: Text(unit.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.unit = value;
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => TextFormField(
                        initialValue: controller.nutritionFacts.value,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Nutrition Facts',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) =>
                            controller.updateNutritionFacts(value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (controller.id.value == -1) {
            ProductDatabase.instance.insertProduct(
              ProductCompanion.insert(
                name: controller.name.value,
                description: Value(controller.description.value),
                productType: controller.category,
                manufactureDate: controller.manufactureDate.value,
                expirationDate: controller.expirationDate.value,
                massVolume: controller.massVolume.value,
                unit: controller.unit,
                nutritionFacts: controller.nutritionFacts.value,
              ),
            );
          } else {
            ProductDatabase.instance.updateProduct(ProductCompanion(
              id: Value(controller.id.value),
              name: Value(controller.name.value),
              description: Value(controller.description.value),
              productType: Value(controller.category),
              manufactureDate: Value(controller.manufactureDate.value),
              expirationDate: Value(controller.expirationDate.value),
              massVolume: Value(controller.massVolume.value),
              unit: Value(controller.unit),
              nutritionFacts: Value(controller.nutritionFacts.value),
            ));
          }
          Get.back();
        },
      ),
    );
  }
}
