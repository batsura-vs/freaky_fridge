import 'package:flutter/material.dart' hide SearchController;
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/pages/creation/product.dart';
import 'package:freaky_fridge/pages/qr/qr_product.dart';
import 'package:get/get.dart';
import 'package:freaky_fridge/controllers/search_controller.dart';
import 'package:intl/intl.dart';

class ProductsPage extends StatelessWidget {
  ProductsPage({super.key});

  final searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ProductDatabase.instance.watchAllProducts(),
      builder: (context, snapshot) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
              isFullScreen: false,
              viewConstraints: const BoxConstraints(
                maxHeight: 300.0,
              ),
              builder: (context, controller) => SearchBar(
                elevation: const WidgetStatePropertyAll(0),
                leading: const Icon(Icons.search),
                hintText: "Поиск",
                controller: controller,
                onTap: () => controller.openView(),
                onSubmitted: (value) {
                  searchController.updateSearchQuery(value);
                },
                onTapOutside: (event) {
                  if (controller.isOpen) {
                    controller.closeView(controller.text);
                    searchController.updateSearchQuery(controller.text);
                  }
                },
                onChanged: (value) {
                  searchController.updateSearchQuery(value);
                },
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => Get.to(
                      () => ProductPage(),
                    ),
                  ),
                ],
              ),
              suggestionsBuilder: (context, controller) {
                List<Widget> suggestions = [];
                if (snapshot.hasData) {
                  for (var product in snapshot.data!) {
                    if (product.name
                        .toLowerCase()
                        .contains(controller.text.toLowerCase())) {
                      suggestions.add(
                        ListTile(
                          title: Text(product.name),
                          onTap: () {
                            controller.closeView(product.name);
                            searchController.updateSearchQuery(product.name);
                          },
                        ),
                      );
                    }
                    if (suggestions.length > 5) {
                      break;
                    }
                  }
                }
                return suggestions;
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: snapshot.hasData
              ? snapshot.data!.isNotEmpty
                  ? Obx(() {
                      final filteredProducts = snapshot.data!
                          .where(
                            (product) => product.name.toLowerCase().contains(
                                  searchController.searchQuery.value
                                      .toLowerCase(),
                                ),
                          )
                          .toList();
                      return ListView.builder(
                        key: UniqueKey(),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(filteredProducts[index].name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Изготовлен: ${DateFormat('yyyy-MM-dd').format(filteredProducts[index].manufactureDate)}',
                                ),
                                Text(
                                  'Истекает: ${DateFormat('yyyy-MM-dd').format(filteredProducts[index].expirationDate)}',
                                ),
                                Text(
                                  'Масса/объем: ${filteredProducts[index].massVolume} ${switch (filteredProducts[index].unit) {
                                    Unit.grams => "Г",
                                    Unit.kilograms => "Кг",
                                    Unit.milliliters => "Мл",
                                    Unit.liters => "Л",
                                    Unit.pieces => "Ш",
                                  }}',
                                ),
                              ],
                            ),
                            onTap: () => Get.to(
                              () => ProductPage(
                                product: filteredProducts[index],
                              ),
                            ),
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(filteredProducts[index].name),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Пищевая ценность: ${filteredProducts[index].nutritionFacts}',
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Закрыть'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.qr_code),
                              onPressed: () => Get.to(
                                () => QrProductWidget(
                                  product: filteredProducts[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                  : const Center(
                      child: Text(
                        "Продуктов пока нет. Пожалуйста, добавьте что-нибудь.",
                      ),
                    )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
