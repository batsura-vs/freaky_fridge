import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/product_controller.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart' hide Value;

class ProductWidget extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  ProductWidget({super.key, ProductData? product}) {
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
              controller.product.value.id.value == -1
                  ? "New Product"
                  : "Edit Product",
            ),
            actions: <Widget>[
              if (controller.product.value.id.value != -1)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    ProductDatabase.instance.deleteProduct(
                      controller.product.value.id.value,
                    );
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
                        initialValue: controller.product.value.name.value,
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
                        initialValue:
                            controller.product.value.description.value ?? '',
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
          if (controller.product.value.id.value == -1) {
            ProductDatabase.instance.insertProduct(
              ProductCompanion.insert(
                name: controller.product.value.name.value,
                description: Value(controller.product.value.description.value),
              ),
            );
          } else {
            ProductDatabase.instance.updateProduct(controller.product.value);
          }
          Get.back();
        },
      ),
    );
  }
}
