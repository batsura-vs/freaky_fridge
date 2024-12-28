import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/nav_controller.dart';
import 'package:freaky_fridge/widgets/qr_scanner.dart';
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
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.list,
                  size: controller.currentIndex.value == 0 ? 30.0 : 24.0,
                ),
                onPressed: () => controller.navigateTo(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: controller.currentIndex.value == 1 ? 30.0 : 24.0,
                ),
                onPressed: () => controller.navigateTo(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  size: controller.currentIndex.value == 2 ? 30.0 : 24.0,
                ),
                onPressed: () => controller.navigateTo(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
