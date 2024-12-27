import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/controllers/product_record_controller.dart';
import 'package:get/get.dart' hide Value;
import 'package:intl/intl.dart';

class ProductRecordWidget extends StatelessWidget {
  final ProductRecordController recordController =
      Get.put(ProductRecordController());

  ProductRecordWidget({super.key, ProductRecordData? product}) {
    if (product != null) {
      recordController.updateProduct(product);
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
              recordController.id.value == -1
                  ? "New Product Record"
                  : "Edit Product Record",
            ),
            actions: <Widget>[
              if (recordController.id.value != -1)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    ProductDatabase.instance.deleteProductRecord(
                      recordController.id.value,
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
                    child: FutureBuilder(
                        future: ProductDatabase.instance.allProducts,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return SearchAnchor(
                            isFullScreen: false,
                            viewConstraints: const BoxConstraints(
                              maxHeight: 300.0,
                            ),
                            builder: (context, controller) => Obx(
                              () => TextFormField(
                                key: UniqueKey(),
                                initialValue: snapshot.data
                                    ?.firstWhereOrNull(
                                      (element) =>
                                          element.id ==
                                          recordController.productId.value,
                                    )
                                    ?.name,
                                decoration: InputDecoration(
                                  labelText: 'Product',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: const Icon(Icons.inventory),
                                ),
                                onTap: () => controller.openView(),
                                onChanged: (value) => controller.openView(),
                              ),
                            ),
                            suggestionsBuilder: (context, controller) {
                              List<Widget> suggestions = [];
                              for (var record in snapshot.data!) {
                                if (record.name
                                    .toLowerCase()
                                    .contains(controller.text.toLowerCase())) {
                                  suggestions.add(
                                    ListTile(
                                      title: Text(record.name),
                                      onTap: () {
                                        controller.closeView(record.name);
                                        recordController
                                            .updateProductId(record.id);
                                      },
                                    ),
                                  );
                                }
                                if (suggestions.length > 5) {
                                  break;
                                }
                              }
                              return suggestions;
                            },
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => TextFormField(
                        initialValue: recordController.amount.toString(),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) => recordController.updateAmount(
                          max(int.tryParse(value) ?? 0, 0),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: recordController.expiration.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          recordController.updateExpiration(pickedDate);
                        }
                      },
                      child: Obx(
                        () => AbsorbPointer(
                          child: TextFormField(
                            key: UniqueKey(),
                            initialValue: DateFormat.yMd().format(
                              recordController.expiration.value,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Expiration Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
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
          if (recordController.id.value == -1) {
            ProductDatabase.instance.insertProductRecord(
              ProductRecordCompanion.insert(
                productId: recordController.productId.value,
                amount: recordController.amount.value,
                expiration: recordController.expiration.value,
              ),
            );
          } else {
            ProductDatabase.instance.updateProductRecord(
              ProductRecordCompanion.insert(
                id: Value(recordController.id.value),
                productId: recordController.productId.value,
                amount: recordController.amount.value,
                expiration: recordController.expiration.value,
              ),
            );
          }
          Get.back();
        },
      ),
    );
  }
}
