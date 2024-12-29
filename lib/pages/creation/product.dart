import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/product_controller.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;

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
              ),
            );
          } else {
            ProductDatabase.instance.updateProduct(ProductCompanion(
              id: Value(controller.id.value),
              name: Value(controller.name.value),
              description: Value(controller.description.value),
            ));
          }
          Get.back();
        },
      ),
    );
  }
}
