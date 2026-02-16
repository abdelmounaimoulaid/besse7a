
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_app/utils/arabic_strings.dart';

class ApiService {
  static const String BASE_URL = 'https://world.openfoodfacts.org/api/v2/product';

  static Future<ProductResult> fetchProduct(String rawBarcode) async {
    final barcode = rawBarcode.trim();
    try {
      if (kDebugMode) {
        print('Fetching product: $barcode');
      }

      // DEMO MODE: Cheat code for Green Score A
      if (barcode == '123456') {
        return ProductResult(
          barcode: '123456',
          name: 'Demo Healthy Product',
          brand: 'Green Choice',
          image: 'https://images.openfoodfacts.org/images/products/327/408/000/5003/front_en.442.400.jpg', // Placeholder
          nutriScore: 'A',
          status: ProductStatus.GOOD,
          ingredients: 'Organic Apples, Water, Vitamin C',
          category: 'Fruits',
          nutrients: {
            ArabicStrings.energy: '52 kcal',
            ArabicStrings.sugar: '10 g',
            ArabicStrings.fat: '0.2 g',
            ArabicStrings.salt: '0.01 g',
            ArabicStrings.protein: '0.3 g',
            ArabicStrings.fiber: '2.4 g',
          },
          novaGroup: 1,
          allergens: [],
          traces: [],
          additivesCount: 2,
          additives: ['E300', 'E330'],
          servingSize: '100g',
          productWeight: 250, // 250g package
          isPerServing: false,
          // HEALTH SCORING VALUES (Required for Green Score)
          sugar: 10.0,
          salt: 0.01,
          saturatedFat: 0.1,
          fiber: 2.4,
          protein: 0.3,
        );
      }
      
      // Fetch only required fields from Open Food Facts to minimize payload
      const fields = 'code,product_name,product_name_fr,product_name_en,product_name_ar,quantity,'
          'brands,categories_tags,image_url,image_front_url,'
          'ingredients_text,ingredients_text_fr,ingredients_text_en,'
          'nutriscore_grade,nutrition_grades,nova_group,'
          'allergens_tags,traces_tags,additives_n,additives_tags,'
          'nutriments,serving_size';
      
      final response = await http.get(
        Uri.parse('$BASE_URL/$barcode.json?fields=$fields'),
        headers: {
          'User-Agent': 'FoodCheckerApp/1.0 (abdelmonaim@example.com) - FlutterMobile',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 0) {
          throw Exception(ArabicStrings.productNotFoundInDatabase);
        }

        return ProductResult.fromJson(data['product'], barcode);
      } else {
        throw Exception('${ArabicStrings.failedToLoadProduct}: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
      rethrow;
    }
  }
}
