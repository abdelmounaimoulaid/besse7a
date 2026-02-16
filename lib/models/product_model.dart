
import 'package:flutter/material.dart';
import 'package:mobile_app/utils/arabic_strings.dart';

enum ProductStatus { GOOD, AVERAGE, BAD, UNKNOWN }

class ProductResult {
  final String barcode;
  final String name;
  final String brand;
  final String? image;
  final String nutriScore;
  final String ingredients;
  final ProductStatus status;
  final Map<String, String> nutrients;
  final String? category;
  
  // Health-related fields for Arabic RTL health insights
  final int? novaGroup;
  final List<String> allergens;
  final List<String> traces;
  final int? additivesCount;
  final List<String> additives; // List of additive tags (e.g., "E330")
  final String? servingSize;
  
  // Individual nutrient values (per 100g or per serving)
  final double? sugar;
  final double? salt;
  final double? saturatedFat;
  final double? fiber;
  final double? protein;
  final bool isPerServing; // true if nutrient data is per serving only
  final double? productWeight; // Product total weight in grams

  // Calculate total nutrient amount in entire package
  double? calculateTotalNutrient(double? nutrientPer100g) {
    if (nutrientPer100g == null || productWeight == null) return null;
    return (nutrientPer100g * productWeight!) / 100;
  }

  // Get total amounts
  double? get totalSugar => calculateTotalNutrient(sugar);
  double? get totalSalt => calculateTotalNutrient(salt);
  double? get totalSaturatedFat => calculateTotalNutrient(saturatedFat);
  double? get totalFiber => calculateTotalNutrient(fiber);
  double? get totalProtein => calculateTotalNutrient(protein);

  ProductResult copyWith({
    double? productWeight,
  }) {
    return ProductResult(
      barcode: barcode,
      name: name,
      brand: brand,
      image: image,
      nutriScore: nutriScore,
      ingredients: ingredients,
      status: status,
      nutrients: nutrients,
      category: category,
      novaGroup: novaGroup,
      allergens: allergens,
      traces: traces,
      additivesCount: additivesCount,
      additives: additives,
      servingSize: servingSize,
      sugar: sugar,
      salt: salt,
      saturatedFat: saturatedFat,
      fiber: fiber,
      protein: protein,
      isPerServing: isPerServing,
      productWeight: productWeight ?? this.productWeight,
    );
  }

  ProductResult({
    required this.barcode,
    required this.name,
    required this.brand,
    this.image,
    required this.nutriScore,
    required this.ingredients,
    required this.status,
    required this.nutrients,
    this.category,
    this.novaGroup,
    this.allergens = const [],
    this.traces = const [],
    this.additivesCount,
    this.additives = const [],
    this.servingSize,
    this.sugar,
    this.salt,
    this.saturatedFat,
    this.fiber,
    this.protein,
    this.isPerServing = false,
    this.productWeight,
  });

  factory ProductResult.fromJson(Map<String, dynamic> json, String barcode) {
    final nutriments = json['nutriments'] as Map<String, dynamic>? ?? {};
    
    // Determine if data is per 100g or per serving
    final bool hasPerServing = nutriments['sugars_serving'] != null ||
        nutriments['salt_serving'] != null ||
        nutriments['saturated-fat_serving'] != null;
    final bool hasPer100g = nutriments['sugars_100g'] != null ||
        nutriments['salt_100g'] != null ||
        nutriments['saturated-fat_100g'] != null;
    final bool useServing = hasPerServing && !hasPer100g;
    
    // Parse product weight from quantity field (e.g., "750g", "1.5kg", "500 ml")
    double? productWeight = _parseProductWeight(json['quantity'] as String?);
    
    return ProductResult(
      barcode: barcode,
      name: json['product_name'] ?? json['product_name_fr'] ?? json['product_name_en'] ?? json['product_name_ar'] ?? ArabicStrings.unknownProduct,
      brand: json['brands'] ?? ArabicStrings.unknownBrand,
      image: json['image_url'] ?? json['image_front_url'],
      nutriScore: (json['nutriscore_grade'] ?? json['nutrition_grades'] ?? '?').toString().toUpperCase(),
      ingredients: json['ingredients_text'] ?? json['ingredients_text_fr'] ?? json['ingredients_text_en'] ?? ArabicStrings.noIngredientsListed,
      status: _calculateStatus(json['nutriscore_grade'] ?? json['nutrition_grades']),
      category: json['categories_tags'] is List && (json['categories_tags'] as List).isNotEmpty 
          ? (json['categories_tags'] as List).first.toString()
          : null,
      nutrients: _parseNutrients(nutriments),
      novaGroup: json['nova_group'] as int?,
      allergens: _parseTagsList(json['allergens_tags']),
      traces: _parseTagsList(json['traces_tags']),
      additivesCount: json['additives_n'] as int?,
      additives: _parseAdditives(json['additives_tags']),
      servingSize: json['serving_size'] as String?,
      sugar: _getNutrientValue(nutriments, 'sugars', useServing),
      salt: _getNutrientValue(nutriments, 'salt', useServing),
      saturatedFat: _getNutrientValue(nutriments, 'saturated-fat', useServing),
      fiber: _getNutrientValue(nutriments, 'fiber', useServing),
      protein: _getNutrientValue(nutriments, 'proteins', useServing),
      isPerServing: useServing,
      productWeight: productWeight,
    );
  }

  static List<String> _parseAdditives(dynamic tags) {
    if (tags is List) {
      return tags.map((t) {
        String tag = t.toString().toUpperCase();
        if (tag.contains(':')) {
           final parts = tag.split(':');
           if (parts.length > 1) {
             tag = parts[1];
           }
        }
        return tag;
      }).toList();
    }
    return [];
  }
  
  // Parse product weight from quantity string (e.g., "750g", "1.5kg", "500 ml", "1,5 L")
  static double? _parseProductWeight(String? quantity) {
    if (quantity == null || quantity.isEmpty) return null;
    
    // Normalize string: lowercase, remove spaces, replace comma with dot
    String cleaned = quantity.toLowerCase().replaceAll(' ', '').replaceAll(',', '.');
    
    // Match patterns like "750g", "1.5kg", "0.75l", "33cl"
    // Regex looks for number followed optionally by unit
    final RegExp regex = RegExp(r'(\d+\.?\d*)\s*(kg|g|mg|l|ml|cl|dl)');
    final match = regex.firstMatch(cleaned);
    
    if (match == null) return null;
    
    final double value = double.tryParse(match.group(1) ?? '') ?? 0;
    final String unit = match.group(2) ?? '';
    
    // Convert everything to grams (for solid) or assume 1ml = 1g for liquids
    switch (unit) {
      case 'kg': return value * 1000;
      case 'g': return value;
      case 'mg': return value / 1000;
      case 'l': return value * 1000;
      case 'ml': return value;
      case 'cl': return value * 10;
      case 'dl': return value * 100;
      default: return null;
    }
  }
  
  static double? _getNutrientValue(Map<String, dynamic> nutriments, String key, bool useServing) {
    final value = useServing 
        ? (nutriments['${key}_serving'] ?? nutriments['${key}_value'])
        : (nutriments['${key}_100g'] ?? nutriments['${key}_value']);
    if (value == null) return null;
    return double.tryParse(value.toString());
  }
  
  static List<String> _parseTagsList(dynamic tags) {
    if (tags is List) {
      return tags.map((t) {
        String tag = t.toString().toLowerCase();
        
        // Check exact match first
        if (ArabicStrings.allergenTranslations.containsKey(tag)) {
          return ArabicStrings.allergenTranslations[tag]!;
        }
        
        // Strip prefixes like en: fr: etc.
        if (tag.contains(':')) {
           final parts = tag.split(':');
           if (parts.length > 1) {
             tag = parts[1];
           }
        }
        
        // Check against dictionary again after stripping prefix
        if (ArabicStrings.allergenTranslations.containsKey(tag)) {
          return ArabicStrings.allergenTranslations[tag]!;
        }
        
        return tag.replaceAll('-', ' ');
      }).toList();
    }
    return [];
  }

  static Map<String, String> _parseNutrients(Map<String, dynamic> nutriments) {
    String formatValue(List<String> keys, String unit) {
      for (final key in keys) {
        final value = nutriments[key];
        if (value != null) {
          try {
            final numValue = double.parse(value.toString());
            // If value is 0 and we have other keys, maybe keep checking? No, 0 is a value.
            return '${numValue.toStringAsFixed(1)} $unit';
          } catch (e) {
            continue;
          }
        }
      }
      return 'N/A';
    }

    return {
      ArabicStrings.energy: formatValue(['energy-kcal_100g', 'energy-kcal_value', 'energy-kcal'], 'kcal'),
      ArabicStrings.fat: formatValue(['fat_100g', 'fat_value', 'fat'], 'g'),
      ArabicStrings.saturatedFat: formatValue(['saturated-fat_100g', 'saturated-fat_value', 'saturated-fat'], 'g'),
      ArabicStrings.carbohydrates: formatValue(['carbohydrates_100g', 'carbohydrates_value', 'carbohydrates'], 'g'),
      ArabicStrings.sugar: formatValue(['sugars_100g', 'sugars_value', 'sugars'], 'g'),
      ArabicStrings.fiber: formatValue(['fiber_100g', 'fiber_value', 'fiber', 'fibre_100g', 'fibre_value', 'fibre'], 'g'),
      ArabicStrings.protein: formatValue(['proteins_100g', 'proteins_value', 'proteins'], 'g'),
      ArabicStrings.salt: formatValue(['salt_100g', 'salt_value', 'salt'], 'g'),
    };
  }

  static ProductStatus _calculateStatus(String? grade) {
    if (grade == null) return ProductStatus.UNKNOWN;
    final g = grade.toLowerCase();
    if (g == 'a' || g == 'b') return ProductStatus.GOOD;
    if (g == 'c') return ProductStatus.AVERAGE;
    if (g == 'd' || g == 'e') return ProductStatus.BAD;
    return ProductStatus.UNKNOWN;
  }
}
