import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/nav_controller.dart';
import 'package:freaky_fridge/pages/qr/qr_scanner.dart';
import 'package:get/get.dart';

class AppEntrypoint extends StatelessWidget {
  final NavigationController controller = Get.find(tag: 'nav');

  AppEntrypoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => controller.pages[controller.currentIndex.value],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code),
        onPressed: () {
          Get.to(() => const BarcodeScannerSimple());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.list_alt,
              ),
              onPressed: () => controller.navigateTo(0),
            ),
            IconButton(
              icon: const Icon(
                Icons.format_list_bulleted,
              ),
              onPressed: () => controller.navigateTo(1),
            ),
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
              ),
              onPressed: () => controller.navigateTo(2),
            ),
            IconButton(
              onPressed: () => controller.navigateTo(3),
              icon: const Icon(
                Icons.add_chart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
