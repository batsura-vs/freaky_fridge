import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/nav_controller.dart';
import 'package:freaky_fridge/pages/qr/qr_scanner.dart';
import 'package:get/get.dart';
import 'dart:async';

class AppEntrypoint extends StatefulWidget {
  const AppEntrypoint({super.key});

  @override
  State<AppEntrypoint> createState() => _AppEntrypointState();
}

class _AppEntrypointState extends State<AppEntrypoint> {
  late final NavigationController controller;
  Timer? _longPressTimer;

  @override
  void initState() {
    super.initState();
    controller = Get.find(tag: 'nav');
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  void _startLongPressTimer() {
    _longPressTimer?.cancel();
    _longPressTimer = Timer(
      const Duration(seconds: 5),
      () => Get.toNamed("/page${controller.currentIndex}"),
    );
  }

  void _cancelLongPressTimer() {
    _longPressTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withBlue(30),
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(
            () => controller.pages[controller.currentIndex.value],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    Icons.home_rounded,
                    'Products',
                    0,
                  ),
                  _buildNavItem(
                    context,
                    Icons.shopping_cart_rounded,
                    'Wishlist',
                    1,
                  ),
                  _buildNavItem(
                    context,
                    Icons.analytics_rounded,
                    'Stats',
                    2,
                  ),
                  _buildScanButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, int index) {
    final isSelected = controller.currentIndex.value == index;
    return InkWell(
      onTap: () => controller.navigateTo(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha((255 * 0.2).toInt()),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withAlpha((255 * 0.7).toInt()),
        ),
      ),
    );
  }

  Widget _buildScanButton(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startLongPressTimer(),
      onLongPressEnd: (_) => _cancelLongPressTimer(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IconButton(
          icon: const Icon(Icons.qr_code_scanner_rounded),
          color: Colors.white,
          onPressed: () => Get.to(() => const BarcodeScannerSimple()),
        ),
      ),
    );
  }
}
