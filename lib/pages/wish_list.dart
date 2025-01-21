import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/wish_list_controller.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart';

class WishList extends StatelessWidget {
  final wishController = Get.put(WishListController());
  WishList({super.key});

  void _showModalBottomSheet(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue:
                      wishController.wishList[index].quantity.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Количество',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    wishController.quantity.value = int.tryParse(value) ?? 0;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                wishController.removeFromWishList(
                  wishController.wishList[index].product,
                );
                Get.back();
              },
              child: const Text('Удалить'),
            ),
            TextButton(
              onPressed: () {
                wishController.updateQuantity(
                  wishController.wishList[index].product,
                  wishController.quantity.value,
                );
                Get.back();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(
              "Список покупок",
            ),
            actions: [],
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
                          builder: (context, controller) => TextFormField(
                            key: UniqueKey(),
                            decoration: InputDecoration(
                              labelText: 'Продукт',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: const Icon(Icons.inventory),
                            ),
                            onTap: () => controller.openView(),
                            onChanged: (value) {
                              controller.openView();
                            },
                          ),
                          suggestionsBuilder: (context, controller) {
                            List<Widget> suggestions = [];
                            for (var product in snapshot.data!) {
                              if (product.name
                                  .toLowerCase()
                                  .contains(controller.text.toLowerCase())) {
                                suggestions.add(
                                  ListTile(
                                    title: Text(product.name),
                                    onTap: () {
                                      controller.closeView(null);
                                      wishController
                                          .updateSearchQuery(product.name);
                                      wishController.addToWishList(
                                        product,
                                        1,
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
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: Obx(
                      () => ListView.builder(
                        itemBuilder: (context, index) => ListTile(
                          title: Text(
                            wishController.wishList[index].product.name,
                          ),
                          subtitle: Text(
                            'Количество: ${wishController.wishList[index].quantity}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              _showModalBottomSheet(context, index);
                            },
                          ),
                        ),
                        itemCount: wishController.wishList.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
