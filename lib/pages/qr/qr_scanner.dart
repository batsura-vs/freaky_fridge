import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/pages/creation/product.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  void _handleBarcode(BarcodeCapture barcodes) async {
    var code = barcodes.barcodes.firstOrNull;
    if (code != null && code.displayValue != null) {
      try {
        final Map<String, dynamic> productData = jsonDecode(code.displayValue!);
        final int? productId = productData['productId'];
        if (await ProductDatabase.instance.getCategoryById(
              productData['productType'] ?? "Default",
            ) ==
            null) {
          await ProductDatabase.instance.insertCategory(
            CategoryCompanion.insert(
              name: productData['productType'] ?? "Default",
            ),
          );
        }
        Get.off(
          () => ProductPage(
            product: ProductData(
              id: productId ?? -1,
              name: productData['name'],
              productType: productData['productType'],
              manufactureDate: DateTime.parse(productData['manufactureDate']),
              expirationDate: DateTime.parse(productData['expirationDate']),
              massVolume: productData['massVolume'],
              unit: productData['unit'],
              nutritionFacts: productData['nutritionFacts'],
            ),
          ),
        );
      } catch (e) {
        debugPrint('Failed to decode JSON: $e');
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple scanner')),
      backgroundColor: Colors.black,
      body: MobileScanner(
        onDetect: _handleBarcode,
      ),
    );
  }
}
