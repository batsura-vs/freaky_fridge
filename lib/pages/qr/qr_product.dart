import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrProductWidget extends StatelessWidget {
  final ProductData product;
  const QrProductWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: ProductDatabase.instance.getCategoryById(product.productType),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final category = snapshot.data!;
          final productData = [
            product.name,
            category.name,
            product.manufactureDate.toIso8601String(),
            product.expirationDate.toIso8601String(),
            product.massVolume,
            product.unit.name,
            product.nutritionFacts,
          ];
          final qrData =
              base64Encode(gzip.encode(utf8.encode(jsonEncode(productData))));
          final painter = QrPainter(
            data: qrData,
            version: QrVersions.auto,
          );
          return Scaffold(
            appBar: AppBar(title: Text(product.name)),
            body: Center(
              child: FutureBuilder(
                future: painter.toImageData(300),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: 300,
                      height: 300,
                      child: Image.memory(
                        snapshot.data!.buffer.asUint8List(),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.share),
              onPressed: () async {
                var data = await painter.toImageData(600);
                if (data == null) {
                  Get.showSnackbar(
                    const GetSnackBar(
                      message: 'Failed to generate QR code',
                    ),
                  );
                  return;
                }
                Share.shareXFiles(
                  [
                    XFile.fromData(data.buffer.asUint8List(),
                        mimeType: 'image/png'),
                  ],
                  fileNameOverrides: ['qr.png'],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
