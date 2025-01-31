import 'dart:convert';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/services/openai_service.dart';
import 'package:drift/drift.dart';

class AllergenService {
  final AppDatabase _db;
  final OpenAIService _openAIService;

  AllergenService({
    required AppDatabase database,
    required OpenAIService openAIService,
  })  : _db = database,
        _openAIService = openAIService;

  Future<List<Map<String, String>>> detectAndSaveAllergens(
    int productId,
    String productName,
    String description,
  ) async {
    // Get allergens from OpenAI
    final detectedAllergens = await _openAIService.detectAllergens(
      productName,
      description,
    );

    final allergensList = detectedAllergens.map((a) => {
      'name': a.name,
      'importance': a.severity,
    }).toList();

    // Update the product with the new allergens list
    if (productId != -1) {
      await _db.updateProduct(
        ProductCompanion(
          id: Value(productId),
          allergens: Value(jsonEncode(allergensList)),
        ),
      );
    }

    return allergensList;
  }

  List<Map<String, String>> getProductAllergens(String allergensJson) {
    if (allergensJson.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(allergensJson);
      return decoded.map((e) => Map<String, String>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> removeAllergenFromProduct(int productId, String allergenName) async {
    final product = (await _db.allProducts).firstWhere((p) => p.id == productId);
    final allergens = getProductAllergens(product.allergens);
    allergens.removeWhere((allergen) => allergen['name'] == allergenName);
    
    await _db.updateProduct(
      ProductCompanion(
        id: Value(productId),
        allergens: Value(jsonEncode(allergens)),
      ),
    );
  }
}
