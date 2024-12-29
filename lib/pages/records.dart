import 'package:flutter/material.dart' hide SearchController;
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/pages/creation/product_record.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:freaky_fridge/controllers/search_controller.dart';

class RecordsPage extends StatelessWidget {
  RecordsPage({super.key});

  final searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ProductDatabase.instance.watchAllProductRecordWithProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
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
                  hintText: "Search",
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
                        () => ProductRecordPage(),
                      ),
                    ),
                  ],
                ),
                suggestionsBuilder: (context, controller) {
                  List<Widget> suggestions = [];
                  for (var record in snapshot.data!) {
                    if (record.product.name
                        .toLowerCase()
                        .contains(controller.text.toLowerCase())) {
                      suggestions.add(
                        ListTile(
                          title: Text(record.product.name),
                          onTap: () {
                            controller.closeView(
                              record.product.name,
                            );
                            searchController.updateSearchQuery(
                              record.product.name,
                            );
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
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: snapshot.hasData
                ? Obx(() {
                    final filteredRecords = snapshot.data!
                        .where(
                          (record) =>
                              record.product.name.toLowerCase().contains(
                                    searchController.searchQuery.value
                                        .toLowerCase(),
                                  ),
                        )
                        .toList();
                    return ListView.builder(
                      key: UniqueKey(),
                      itemCount: filteredRecords.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            isThreeLine: true,
                            title: Text(
                              filteredRecords[index].product.name,
                            ),
                            subtitle: Row(
                              children: [
                                Chip(
                                  label: Text(
                                    "${filteredRecords[index].record.amount}x",
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                ExpirationChip(
                                  product: filteredRecords[index].record,
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Get.to(
                                  () => ProductRecordPage(
                                    product: filteredRecords[index].record,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  })
                : const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class ExpirationChip extends StatelessWidget {
  final ProductRecordData product;
  const ExpirationChip({
    super.key,
    required this.product,
  });

  Color _getColor(DateTime expiration) {
    if (expiration.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return Colors.red;
    }
    if (expiration.isBefore(DateTime.now().subtract(const Duration(days: 2)))) {
      return Colors.yellow;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        Icons.calendar_month,
        color: _getColor(product.expiration),
      ),
      label: Text(
        DateFormat.Md().format(product.expiration),
      ),
    );
  }
}
