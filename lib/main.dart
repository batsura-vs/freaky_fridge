import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/nav.dart';
import 'package:freaky_fridge/entrypoint/entrypoit.dart';
import 'package:freaky_fridge/pages/products.dart';
import 'package:freaky_fridge/pages/records.dart';
import 'package:get/get.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(
      NavigationController(
        pages: [
          const RecordsPage(),
          const ProductsPage(),
          const Text("data3"),
        ],
        index: 0,
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
