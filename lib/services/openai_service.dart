import 'package:xml/xml.dart';
import 'package:freaky_fridge/models/allergen_dto.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class OpenAIService {
  final String apiKey;
  late Dio _dio;
  static const String _baseUrl = 'https://api.together.xyz/v1';

  OpenAIService({
    this.apiKey = "587962ec248fce2e9dbd8dfe33a3fd95858c0bfe2ae50fa0e6b031f7537c6c7f",
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    ));
  }

  String _getAllergensPrompt(String productName, String description) {
    return '''
Проанализируйте следующий продукт и перечислите потенциальные аллергены. 
Верните результат в формате XML, где каждый аллерген находится в теге <allergen> с атрибутами:
- name: название аллергена на русском
- severity: high/medium/low
- description: описание и влияние аллергена
Оберните весь ответ в корневой тег <allergens>.

Название продукта: $productName
Описание: $description

Пример ответа:
<allergens>
  <allergen name="Молоко" severity="high" description="Содержит белки молока, которые могут вызвать аллергическую реакцию"/>
  <allergen name="Соя" severity="medium" description="Присутствуют соевые компоненты"/>
</allergens>
''';
  }

  Future<List<AllergenDTO>> detectAllergens(
      String productName, String description) async {
    try {
      final messages = [
        {
          'role': 'user',
          'content':
              'Вы - ассистент, который анализирует продукты питания и определяет потенциальные аллергены. Всегда возвращайте ответ в формате XML.'
        },
        {
          'role': 'user',
          'content': _getAllergensPrompt(productName, description)
        },
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'meta-llama/Llama-3.3-70B-Instruct-Turbo-Free',
          'messages': messages,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      try {
        final document = XmlDocument.parse(content);
        final allergens = document.findAllElements('allergen').map((allergen) {
          final attributes = {
            'name': allergen.getAttribute('name'),
            'severity': allergen.getAttribute('severity'),
            'description': allergen.getAttribute('description'),
          };
          return AllergenDTO.fromXml(attributes);
        }).toList();
        return allergens;
      } catch (e) {
        throw Exception('Не удалось разобрать XML ответ от API: $e');
      }
    } catch (e) {
      throw Exception('Ошибка при запросе к API: $e');
    }
  }

  String _formatBase64Image(String base64Image) {
    // Check if the base64 string already contains the data URI prefix
    if (base64Image.startsWith('data:image')) {
      return base64Image;
    }

    // Try to detect image format from the first few bytes
    try {
      final bytes = base64Decode(base64Image);
      final mimeType = _detectMimeType(bytes);
      return 'data:$mimeType;base64,$base64Image';
    } catch (e) {
      // If we can't detect the format, default to JPEG
      return 'data:image/jpeg;base64,$base64Image';
    }
  }

  String _detectMimeType(Uint8List bytes) {
    if (bytes.length < 4) return 'image/jpeg';

    // Check file signatures
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return 'image/jpeg';
    } else if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    } else if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
      return 'image/gif';
    }

    return 'image/jpeg'; // Default to JPEG if unknown
  }

  Future<Map<String, dynamic>> analyzeProductImage(String base64Image) async {
    try {
      final formattedImage = _formatBase64Image(base64Image);

      final messages = [
        {
          'role': 'user',
          'content':
              '''Вы - ассистент по анализу фотографий продуктов питания. Ваша задача - предоставить точную информацию о продукте в строго заданном XML формате.

ВАЖНЫЕ ПРАВИЛА:
1. Всегда возвращайте ТОЛЬКО XML, без дополнительного текста
2. Числовые значения должны быть только цифрами, без текста
3. Срок годности (expirationDays) должен быть целым числом дней
4. Для единиц измерения (unit) используйте ТОЛЬКО одно из следующих значений:
   - pieces (для штучных товаров)
   - grams (для граммов)
   - kilograms (для килограммов)
   - milliliters (для миллилитров)
   - liters (для литров)

Формат ответа:
<product>
  <name>название продукта на русском</name>
  <category>категория продукта на русском</category>
  <description>подробное описание продукта и упаковки на русском</description>
  <expirationDays>целое число дней</expirationDays>
  <massVolume>число</massVolume>
  <unit>единица измерения из списка выше</unit>
</product>

Пример правильного ответа:
<product>
  <name>Молоко Простоквашино</name>
  <category>Молочные продукты</category>
  <description>Пастеризованное молоко 2.5% жирности в пластиковой бутылке белого цвета</description>
  <expirationDays>14</expirationDays>
  <massVolume>930</massVolume>
  <unit>milliliters</unit>
</product>'''
        },
        {
          'role': 'user',
          'content': [
            {
              'type': 'text',
              'text':
                  'Проанализируйте этот продукт и предоставьте информацию в требуемом формате.'
            },
            {
              'type': 'image_url',
              'image_url': {'url': formattedImage}
            }
          ]
        },
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'meta-llama/Llama-Vision-Free',
          'messages': messages,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      try {
        // Extract XML from the response if it's wrapped in other text
        final xmlRegex = RegExp(r'<product>.*?</product>', dotAll: true);
        final match = xmlRegex.firstMatch(content);
        final xmlContent = match?.group(0) ?? content;

        final document = XmlDocument.parse(xmlContent);
        final product = document.findElements('product').first;
        
        // Helper function to safely get element text
        String getElementText(String elementName) {
          final elements = product.findElements(elementName);
          return elements.isEmpty ? '' : elements.first.innerText.trim();
        }

        final productInfo = {
          'name': getElementText('name'),
          'category': getElementText('category'),
          'description': getElementText('description'),
          'expirationDays': int.tryParse(getElementText('expirationDays')) ?? 0,
          'massVolume': double.tryParse(getElementText('massVolume')) ?? 0.0,
          'unit': getElementText('unit'),
        };
        return productInfo;
      } catch (e) {
        throw Exception('Не удалось разобрать XML ответ от API: $e');
      }
    } catch (e) {
      throw Exception('Ошибка при анализе изображения: $e');
    }
  }
}
