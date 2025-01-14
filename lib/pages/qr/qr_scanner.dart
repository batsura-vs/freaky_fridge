import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/database/models/product.dart';
import 'package:freaky_fridge/pages/creation/product.dart';
import 'dart:convert';
import 'dart:io';
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
      // try {
      final String qrData = code.displayValue!;
      final decodedBytes = base64Decode(qrData);
      final decompressedBytes = gzip.decode(decodedBytes);
      final decodedString = utf8.decode(decompressedBytes);
      final List<dynamic> productData = jsonDecode(decodedString);
      final prType = productData[1];
      final categ = await ProductDatabase.instance.getCategoryByName(prType);
      int catId = categ?.id ?? -1;
      if (catId == -1) {
        catId = await ProductDatabase.instance.insertCategory(
          CategoryCompanion.insert(
            name: prType ?? "Default",
          ),
        );
      }
      Get.off(
        () => ProductPage(
          product: ProductData(
            id: -1,
            name: productData[0],
            productType: catId,
            manufactureDate: DateTime.parse(productData[2]),
            expirationDate: DateTime.parse(productData[3]),
            massVolume: productData[4],
            unit: Unit.values.firstWhere((u) => u.name == productData[5]),
            nutritionFacts: productData[6],
          ),
        ),
      );
      // } catch (e) {
      //   debugPrint('Failed to decode QR code: $e');
      //   return;
      // }
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
