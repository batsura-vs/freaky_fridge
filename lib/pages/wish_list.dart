import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/wish_list_controller.dart';
import 'package:get/get.dart';

class WishList extends StatelessWidget {
  final wishController = Get.put(WishListController());
  final _textController = TextEditingController();

  WishList({super.key});

  void _showModalBottomSheet(BuildContext context, int index) {
    final currentQuantity = wishController.wishList[index].quantity;
    wishController.quantity.value = currentQuantity;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 3,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 32,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha((255 * 0.2).toInt()),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        wishController.wishList[index].productName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        onPressed: () {
                          Get.back();
                          _showDeleteConfirmation(
                            context,
                            wishController.wishList[index].productName,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Количество',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .cardColor
                          .withAlpha((255 * 0.3).toInt()),
                      border: Border.all(
                        color: Theme.of(context)
                            .dividerColor
                            .withAlpha((255 * 0.1).toInt()),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (wishController.quantity.value > 1) {
                                  wishController.quantity.value--;
                                }
                              },
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  Icons.remove,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.symmetric(
                                  vertical: BorderSide(
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withAlpha((255 * 0.1).toInt()),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Obx(() => TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: TextEditingController(
                                        text:
                                            '${wishController.quantity.value}',
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        fillColor: Colors.transparent,
                                        filled: false,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        final newValue = int.tryParse(value);
                                        if (newValue != null && newValue > 0) {
                                          wishController.quantity.value =
                                              newValue;
                                        }
                                      },
                                    )),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                wishController.quantity.value++;
                              },
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  Icons.add,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Отмена'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            await wishController.updateQuantity(
                              wishController.wishList[index].productName,
                              wishController.quantity.value,
                            );
                            Get.back();
                            _showSnackBar('Количество обновлено');
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Сохранить'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение'),
          content: Text('Удалить "$productName" из списка?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Отмена'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                await wishController.removeFromWishList(productName);
                Get.back();
                _showSnackBar('Продукт удален');
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addItem() {
    final value = _textController.text.trim();
    if (value.isNotEmpty) {
      wishController.addToWishList(value, 1);
      _textController.clear();
      _showSnackBar('Продукт добавлен');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("Список покупок"),
            floating: true,
            snap: true,
            elevation: 2,
            forceElevated: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Добавить продукт',
                  filled: true,
                  fillColor: Theme.of(context)
                      .cardColor
                      .withAlpha((255 * 0.3).toInt()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addItem(),
                  ),
                  suffixIcon: null,
                ),
                onSubmitted: (value) => _addItem(),
              ),
            ),
          ),
          Obx(() {
            if (wishController.wishList.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha((255 * 0.5).toInt()),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Список покупок пуст',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Добавьте продукты, которые хотите купить',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = wishController.sortedWishList[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _showModalBottomSheet(context, index),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isChecked,
                              onChanged: (bool? value) {
                                wishController.toggleItemChecked(item.id);
                              },
                            ),
                            Expanded(
                              child: Text(
                                item.productName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      decoration: item.isChecked
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: item.isChecked
                                          ? Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.color
                                              ?.withAlpha((255 * 0.5).toInt())
                                          : Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.color,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha((255 * 0.1).toInt()),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: wishController.sortedWishList.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}
