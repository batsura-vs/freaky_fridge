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
  final selectedCategory = RxInt(-1);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AppDatabase.instance.watchAllProducts(),
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          title: _buildSearchBar(context, snapshot),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 8,
        ),
        body: Column(
          children: [
            _buildCategoryFilter(),
            Expanded(
              child: _buildBody(context, snapshot),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, AsyncSnapshot<List<ProductData>> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SearchAnchor(
        isFullScreen: false,
        viewConstraints: const BoxConstraints(maxHeight: 300.0),
        builder: (BuildContext context, TextEditingController controller) =>
            SearchBar(
          elevation: const WidgetStatePropertyAll(2),
          backgroundColor: WidgetStatePropertyAll(Theme.of(context).cardColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16.0)),
          leading: const Icon(Icons.search, color: Colors.white, size: 24),
          hintText: "Поиск продуктов",
          hintStyle: WidgetStatePropertyAll(
            TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withAlpha((255 * 0.5).toInt()),
            ),
          ),
          textStyle:
              WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium),
          controller: controller,
          onTap: () => controller.clear(),
          onSubmitted: searchController.updateSearchQuery,
          onTapOutside: (event) {
            searchController.updateSearchQuery(controller.text);
          },
          onChanged: searchController.updateSearchQuery,
          trailing: [_buildAddButton()],
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
                      controller.text = product.name;
                      searchController.updateSearchQuery(product.name);
                    },
                  ),
                );
                if (suggestions.length > 5) break;
              }
            }
          }
          return suggestions;
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return IconButton(
      icon: const Icon(Icons.add, color: Colors.white, size: 24),
      onPressed: () => Get.to(() => ProductPage()),
    );
  }

  Widget _buildCategoryFilter() {
    return StreamBuilder<List<CategoryData>>(
      stream: AppDatabase.instance.categoryRepository.watchAllCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        return Container(
          height: 48,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (context, index) => index == 0
                ? _buildAllCategoryChip()
                : _buildCategoryChip(snapshot.data![index - 1]),
          ),
        );
      },
    );
  }

  Widget _buildAllCategoryChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Obx(() => FilterChip(
            selected: selectedCategory.value == -1,
            label: const Text('Все'),
            onSelected: (selected) {
              if (selected) selectedCategory.value = -1;
            },
            showCheckmark: false,
            visualDensity: VisualDensity.compact,
          )),
    );
  }

  Widget _buildCategoryChip(CategoryData category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Obx(() => FilterChip(
            selected: selectedCategory.value == category.id,
            label: Text(category.name),
            labelStyle: TextStyle(
              color: selectedCategory.value == category.id
                  ? Color(category.color)
                  : Colors.white
                ..withAlpha((255 * 0.8).toInt()),
            ),
            backgroundColor: Color(category.color)
              ..withAlpha((255 * 0.2).toInt()),
            selectedColor: Color(category.color)
              ..withAlpha((255 * 0.3).toInt()),
            onSelected: (selected) {
              selectedCategory.value = selected ? category.id : -1;
            },
            showCheckmark: false,
            visualDensity: VisualDensity.compact,
          )),
    );
  }

  Widget _buildBody(
      BuildContext context, AsyncSnapshot<List<ProductData>> snapshot) {
    if (!snapshot.hasData) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white70));
    }

    if (snapshot.data!.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(() {
        final filteredProducts = snapshot.data!
            .where(
              (product) =>
                  (selectedCategory.value == -1 ||
                      product.productType == selectedCategory.value) &&
                  product.name.toLowerCase().contains(
                      searchController.searchQuery.value.toLowerCase()),
            )
            .toList();

        return ListView.builder(
          key: UniqueKey(),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) =>
              _buildProductCard(context, filteredProducts[index]),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_food, size: 64, color: Colors.white30),
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
            style: TextStyle(fontSize: 16, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductData product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashColor: Colors.white..withAlpha((255 * 0.1).toInt()),
          highlightColor: Colors.white..withAlpha((255 * 0.05).toInt()),
          borderRadius: BorderRadius.circular(12),
          onTap: () => Get.to(() => ProductPage(product: product)),
          onLongPress: () => _showNutritionDialog(context, product),
          child: _buildProductCardContent(product),
        ),
      ),
    );
  }

  void _showNutritionDialog(BuildContext context, ProductData product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          product.name,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
            Text(product.nutritionFacts,
                style: Theme.of(context).textTheme.bodyMedium),
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
  }

  Widget _buildProductCardContent(ProductData product) {
    return FutureBuilder<CategoryData>(
      future: AppDatabase.instance.getCategoryById(product.productType),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final category = snapshot.data!;
        return Row(
          children: [
            Container(
              width: 4,
              height: 80,
              decoration: BoxDecoration(
                color: Color(category.color),
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(12)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(child: _buildProductInfo(product, category)),
                    _buildQrButton(product),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductInfo(ProductData product, CategoryData category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          category.name,
          style: TextStyle(
            fontSize: 13,
            color: Color(category.color)..withAlpha((255 * 0.8).toInt()),
          ),
        ),
        const SizedBox(height: 8),
        _buildProductDetails(product),
      ],
    );
  }

  Widget _buildProductDetails(ProductData product) {
    final daysUntilExpiration =
        product.expirationDate.difference(DateTime.now()).inDays;
    final expirationColor = _getExpirationColor(daysUntilExpiration);

    return Row(
      children: [
        Icon(Icons.event, size: 14, color: expirationColor),
        const SizedBox(width: 4),
        Text(
          DateFormat('dd.MM.yyyy').format(product.expirationDate),
          style: TextStyle(fontSize: 13, color: expirationColor),
        ),
        const SizedBox(width: 16),
        Icon(Icons.scale,
            size: 14, color: Colors.white..withAlpha((255 * 0.6).toInt())),
        const SizedBox(width: 4),
        Text(
          '${product.massVolume} ${_getUnitLabel(product.unit)}',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white..withAlpha((255 * 0.6).toInt()),
          ),
        ),
      ],
    );
  }

  Color _getExpirationColor(int daysUntilExpiration) {
    if (daysUntilExpiration < 0) {
      return Colors.red..withAlpha((255 * 0.8).toInt());
    }
    if (daysUntilExpiration <= 3) {
      return Colors.red..withAlpha((255 * 0.6).toInt());
    }
    if (daysUntilExpiration <= 7) {
      return Colors.orange..withAlpha((255 * 0.7).toInt());
    }
    return Colors.white..withAlpha((255 * 0.6).toInt());
  }

  String _getUnitLabel(Unit unit) {
    return switch (unit) {
      Unit.grams => "г",
      Unit.kilograms => "кг",
      Unit.milliliters => "мл",
      Unit.liters => "л",
      Unit.pieces => "шт",
    };
  }

  Widget _buildQrButton(ProductData product) {
    return IconButton(
      icon: Icon(
        Icons.qr_code,
        color: Colors.white..withAlpha((255 * 0.6).toInt()),
        size: 20,
      ),
      onPressed: () => Get.to(() => QrProductWidget(product: product)),
    );
  }
}
