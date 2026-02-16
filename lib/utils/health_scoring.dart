import 'package:flutter/material.dart';
import 'package:mobile_app/models/product_model.dart';
import 'package:mobile_app/utils/arabic_strings.dart';

// Health scoring utility for Open Food Facts data
// Implements exact color codes and thresholds as specified

class HealthScoring {
  // Nutri-Score color mapping (exact hex)
  static Color mapNutriScoreToColor(String? grade) {
    if (grade == null) return const Color(0xFF9CA3AF); // unknown
    switch (grade.toUpperCase()) {
      case 'A':
        return const Color(0xFF16A34A);
      case 'B':
        return const Color(0xFF22C55E);
      case 'C':
        return const Color(0xFFEAB308);
      case 'D':
        return const Color(0xFFF97316);
      case 'E':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF9CA3AF); // unknown
    }
  }

  // NOVA group color mapping (exact hex)
  static Color mapNovaToColor(int? group) {
    if (group == null) return const Color(0xFF9CA3AF); // unknown
    switch (group) {
      case 1:
        return const Color(0xFF16A34A);
      case 2:
        return const Color(0xFF22C55E);
      case 3:
        return const Color(0xFFF97316);
      case 4:
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF9CA3AF); // unknown
    }
  }

  // Compute overall label based on scoring logic
  static Map<String, dynamic> computeOverallLabel(ProductResult product) {
    final nutriScore = product.nutriScore;
    final nova = product.novaGroup;
    final sugar = product.sugar;
    final salt = product.salt;
    final satFat = product.saturatedFat;

    // Check if we have enough data
    if ((nutriScore == '?' || nutriScore.isEmpty) &&
        nova == null &&
        sugar == null &&
        salt == null &&
        satFat == null) {
      return {
        'label': 'unknown',
        'arabicText': ArabicStrings.unknown,
        'color': const Color(0xFF9CA3AF),
      };
    }

    // Count high negatives (sugar, salt, sat fat)
    int highCount = 0;
    if (sugar != null && sugar > 12.5) highCount++;
    if (salt != null && salt > 1.5) highCount++;
    if (satFat != null && satFat > 5) highCount++;

    final nutriGrade = nutriScore.toUpperCase();
    final isBadNutri = nutriGrade == 'D' || nutriGrade == 'E';
    final isBadNova = nova == 4;
    final isGoodNutri = nutriGrade == 'A' || nutriGrade == 'B';
    final isGoodNova = nova == 1 || nova == 2;

    // better_choice: Nutri A/B AND NOVA 1/2 AND no high negatives
    if (isGoodNutri && isGoodNova && highCount == 0) {
      return {
        'label': 'better_choice',
        'arabicText': ArabicStrings.betterChoice,
        'color': const Color(0xFF16A34A),
      };
    }

    // limit: Nutri D/E OR NOVA 4 OR 2+ high negatives
    if (isBadNutri || isBadNova || highCount >= 2) {
      return {
        'label': 'limit',
        'arabicText': ArabicStrings.limit,
        'color': const Color(0xFFDC2626),
      };
    }

    // otherwise ok_sometimes
    return {
      'label': 'ok_sometimes',
      'arabicText': ArabicStrings.okSometimes,
      'color': const Color(0xFFEAB308),
    };
  }

  // Evaluate nutrient quality for UI (Returns {label, color, icon})
  static Map<String, dynamic> getNutrientEvaluation(String type, double value, bool isLiquid) {
    // Colors
    const green = Color(0xFF16A34A);
    const orange = Color(0xFFF97316);
    const red = Color(0xFFDC2626);

    String label = '';
    Color color = green;
    IconData icon = Icons.info;

    switch (type) {
      case 'sugar':
        if (value <= 4.5) { // Solid threshold
          label = 'كمية سكر قليلة'; // Low sugar
          color = green;
        } else if (value <= 22.5) {
          label = 'كمية سكر متوسطة'; // Moderate sugar
          color = orange;
        } else {
          label = 'كمية سكر عالية'; // High sugar
          color = red;
        }
        icon = Icons.opacity; // Cube/Drop
        break;

      case 'salt':
        if (value <= 0.3) {
          label = 'كمية ملح قليلة'; // Low salt
          color = green;
        } else if (value <= 1.5) {
          label = 'كمية ملح متوسطة'; // Moderate salt
          color = orange;
        } else {
          label = 'كمية ملح عالية'; // High salt
          color = red;
        }
        icon = Icons.grain; // Salt shaker equivalent
        break;

      case 'saturated-fat':
        if (value <= 1.5) {
          label = 'دهون مشبعة قليلة'; // Low sat fat
          color = green;
        } else if (value <= 5) {
          label = 'دهون مشبعة متوسطة'; // Moderate sat fat
          color = orange;
        } else {
          label = 'دهون مشبعة عالية'; // High sat fat
          color = red;
        }
        icon = Icons.water_drop;
        break;

      case 'fiber':
        if (value >= 7) {
          label = 'كمية ألياف ممتازة'; // Excellent fiber
          color = green;
        } else if (value >= 3.5) {
          label = 'كمية ألياف جيدة'; // Good fiber
          color = green.withOpacity(0.8);
        } else {
          label = 'كمية ألياف قليلة'; // Low fiber
          color = orange;
        }
        icon = Icons.grass;
        break;

      case 'protein':
        if (value >= 8) { // Arbitrary high threshold
          label = 'كمية بروتين ممتازة'; // Excellent protein
          color = green;
        } else if (value >= 4) {
          label = 'كمية بروتين جيدة'; 
          color = green.withOpacity(0.8);
        } else {
          label = 'كمية بروتين متوسطة';
          color = orange;
        }
        icon = Icons.fitness_center;
        break;
        
      default:
        label = 'غير معروف';
        color = const Color(0xFF9CA3AF);
    }

    return {
      'label': label,
      'color': color,
      'icon': icon,
    };
  }
}
