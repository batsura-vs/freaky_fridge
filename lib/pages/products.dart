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
      stream: AppDatabase.instance.watchAllProducts(),
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
                elevation: const WidgetStatePropertyAll(2),
                backgroundColor: WidgetStatePropertyAll(Theme.of(context).cardColor),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                leading: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
                hintText: "Поиск продуктов",
                hintStyle: WidgetStatePropertyAll(
                  TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha((255 * 0.5).toInt()),
                  ),
                ),
                textStyle: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.bodyMedium,
                ),
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
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
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
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              splashColor: Colors.white.withAlpha((255 * 0.1).toInt()),
                              highlightColor: Colors.white.withAlpha((255 * 0.05).toInt()),
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Get.to(
                                () => ProductPage(
                                  product: filteredProducts[index],
                                ),
                              ),
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      filteredProducts[index].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Theme.of(context).cardColor,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Пищевая ценность:',
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          filteredProducts[index].nutritionFacts,
                                          style: Theme.of(context).textTheme.bodyMedium,
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
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            filteredProducts[index].name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Изготовлен: ${DateFormat('dd.MM.yyyy').format(filteredProducts[index].manufactureDate)}',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.event,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Истекает: ${DateFormat('dd.MM.yyyy').format(filteredProducts[index].expirationDate)}',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.scale,
                                                size: 20,
                                                color: Colors.white70,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Масса/объем: ${filteredProducts[index].massVolume} ${switch (filteredProducts[index].unit) {
                                                  Unit.grams => "г",
                                                  Unit.kilograms => "кг",
                                                  Unit.milliliters => "мл",
                                                  Unit.liters => "л",
                                                  Unit.pieces => "шт",
                                                }}',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.qr_code,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: () => Get.to(
                                        () => QrProductWidget(
                                          product: filteredProducts[index],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.no_food,
                            size: 64,
                            color: Colors.white30,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Продуктов пока нет",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Пожалуйста, добавьте что-нибудь",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white70,
                  ),
                ),
        ),
      ),
    );
  }
}
