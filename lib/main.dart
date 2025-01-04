import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/nav_controller.dart';
import 'package:freaky_fridge/pages/stats.dart';
import 'package:freaky_fridge/entrypoint/entrypoit.dart';
import 'package:freaky_fridge/pages/products.dart';
import 'package:freaky_fridge/pages/records.dart';
import 'package:freaky_fridge/pages/wish_list.dart';
import 'package:get/get.dart';

import 'package:freaky_fridge/services/expiration_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final expirationService = ExpirationService();
  await expirationService.init();
  expirationService.checkExpirations();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(
      NavigationController(
        pages: [
          RecordsPage(),
          ProductsPage(),
          WishList(),
          const StatsPage(),
        ],
        index: 1,
      ),
      tag: 'nav',
    );
    return GetMaterialApp(
      title: 'Freaky Fridge Vers Z',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: AppEntrypoint(),
    );
  }
}
