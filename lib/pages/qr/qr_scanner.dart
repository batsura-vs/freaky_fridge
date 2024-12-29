import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/pages/creation/product_record.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  void _handleBarcode(BarcodeCapture barcodes) {
    var code = barcodes.barcodes.firstOrNull;
    if (code != null && code.displayValue != null) {
      int? id = int.tryParse(code.displayValue!);
      if (id == null) {
        return;
      }
      Get.off(
        () => ProductRecordPage(
          product: ProductRecordData(
            productId: id,
            id: -1,
            amount: 1,
            expiration: DateTime.now(),
          ),
        ),
      );
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
