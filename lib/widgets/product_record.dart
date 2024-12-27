import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/controllers/product_record_controller.dart';
import 'package:get/get.dart';
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
              recordController.record.value.id.value == -1
                  ? "New Product Record"
                  : "Edit Product Record",
            ),
            actions: <Widget>[
              if (recordController.record.value.id.value != -1)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    ProductDatabase.instance.deleteProductRecord(
                      recordController.record.value.id.value,
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
                            builder: (context, controller) => TextField(
                              controller: controller,
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
                    child: TextFormField(
                      initialValue:
                          recordController.record.value.amount.value.toString(),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) => recordController
                          .updateAmount(int.tryParse(value) ?? 0),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              recordController.record.value.expiration.value,
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
                            initialValue: DateFormat.yMd().format(
                              recordController.record.value.expiration.value,
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
          print(recordController.record.value);
          if (recordController.record.value.id.value == -1) {
            ProductDatabase.instance.insertProductRecord(
              ProductRecordCompanion.insert(
                productId: recordController.record.value.productId.value,
                amount: recordController.record.value.amount.value,
                expiration: recordController.record.value.expiration.value,
              ),
            );
          } else {
            ProductDatabase.instance.updateProductRecord(
              recordController.record.value,
            );
          }
          Get.back();
        },
      ),
    );
  }
}
