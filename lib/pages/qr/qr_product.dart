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
        future: AppDatabase.instance.getCategoryById(product.productType),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return const Center(child: _QrPlaceholder());
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
            appBar: AppBar(
              title: Text(product.name),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Отсканируйте этот QR-код для импорта данных о продукте',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Hero(
                        tag: 'qr_code',
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => _FullscreenQR(
                                    painter: painter,
                                    productName: product.name,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FutureBuilder(
                                future: painter.toImageData(
                                  MediaQuery.of(context).size.width * 0.75,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Image.memory(
                                          snapshot.data!.buffer.asUint8List(),
                                        ),
                                      ),
                                    );
                                  }
                                  return const AspectRatio(
                                    aspectRatio: 1,
                                    child: _QrPlaceholder(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Нажмите для полноэкранного просмотра',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Категория', category.name),
                            const Divider(),
                            _buildInfoRow('Количество',
                                '${product.massVolume} ${product.unit.name}'),
                            const Divider(),
                            _buildInfoRow('Дата производства',
                                _formatDate(product.manufactureDate)),
                            const Divider(),
                            _buildInfoRow(
                                'Срок годности', _formatDate(product.expirationDate)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.share),
              label: const Text('Поделиться QR-кодом'),
              onPressed: () async {
                var data = await painter.toImageData(600);
                if (data == null) {
                  Get.showSnackbar(
                    const GetSnackBar(
                      message: 'Не удалось сгенерировать QR-код',
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                Share.shareXFiles(
                  [
                    XFile.fromData(
                      data.buffer.asUint8List(),
                      mimeType: 'image/png',
                    ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _FullscreenQR extends StatelessWidget {
  final QrPainter painter;
  final String productName;

  const _FullscreenQR({
    required this.painter,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(productName),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Закрыть',
        ),
      ),
      body: Center(
        child: Hero(
          tag: 'qr_code',
          child: Card(
            margin: const EdgeInsets.all(24),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: FutureBuilder(
              future: painter.toImageData(
                MediaQuery.of(context).size.width,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.memory(
                          snapshot.data!.buffer.asUint8List(),
                        ),
                      ),
                    ),
                  );
                }
                return const AspectRatio(
                  aspectRatio: 1,
                  child: _QrPlaceholder(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _QrPlaceholder extends StatefulWidget {
  const _QrPlaceholder();

  @override
  State<_QrPlaceholder> createState() => _QrPlaceholderState();
}

class _QrPlaceholderState extends State<_QrPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.5,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _QrPlaceholderPainter(
              opacity: _animation.value,
            ),
          );
        },
      ),
    );
  }
}

class _QrPlaceholderPainter extends CustomPainter {
  final double opacity;

  _QrPlaceholderPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withAlpha((255 * opacity).toInt())
      ..style = PaintingStyle.fill;

    final cellSize = size.width / 7;

    // Draw corner squares
    _drawCornerSquare(canvas, paint, 0, 0, cellSize);
    _drawCornerSquare(canvas, paint, size.width - 3 * cellSize, 0, cellSize);
    _drawCornerSquare(canvas, paint, 0, size.height - 3 * cellSize, cellSize);

    // Draw some random squares to simulate QR code pattern
    final random = [
      [2, 2],
      [4, 1],
      [1, 4],
      [3, 3],
      [5, 2],
      [2, 5],
      [4, 4]
    ];

    for (final pos in random) {
      canvas.drawRect(
        Rect.fromLTWH(
          pos[0] * cellSize,
          pos[1] * cellSize,
          cellSize,
          cellSize,
        ),
        paint,
      );
    }
  }

  void _drawCornerSquare(
      Canvas canvas, Paint paint, double x, double y, double cellSize) {
    canvas.drawRect(
      Rect.fromLTWH(x, y, cellSize * 3, cellSize * 3),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
          x + cellSize * 0.5, y + cellSize * 0.5, cellSize * 2, cellSize * 2),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      Rect.fromLTWH(x + cellSize, y + cellSize, cellSize, cellSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _QrPlaceholderPainter oldDelegate) {
    return opacity != oldDelegate.opacity;
  }
}
