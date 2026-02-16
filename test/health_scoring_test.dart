import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/utils/health_scoring.dart';
import 'package:mobile_app/models/product_model.dart';
import 'package:mobile_app/utils/arabic_strings.dart';

void main() {
  group('Nutri-Score Color Mapping', () {
    test('Grade A maps to correct color', () {
      expect(HealthScoring.mapNutriScoreToColor('A'), const Color(0xFF16A34A));
      expect(HealthScoring.mapNutriScoreToColor('a'), const Color(0xFF16A34A));
    });

    test('Grade B maps to correct color', () {
      expect(HealthScoring.mapNutriScoreToColor('B'), const Color(0xFF22C55E));
    });

    test('Grade C maps to correct color', () {
      expect(HealthScoring.mapNutriScoreToColor('C'), const Color(0xFFEAB308));
    });

    test('Grade D maps to correct color', () {
      expect(HealthScoring.mapNutriScoreToColor('D'), const Color(0xFFF97316));
    });

    test('Grade E maps to correct color', () {
      expect(HealthScoring.mapNutriScoreToColor('E'), const Color(0xFFDC2626));
    });

    test('Unknown grade maps to gray', () {
      expect(HealthScoring.mapNutriScoreToColor(null), const Color(0xFF9CA3AF));
      expect(HealthScoring.mapNutriScoreToColor('?'), const Color(0xFF9CA3AF));
      expect(HealthScoring.mapNutriScoreToColor('X'), const Color(0xFF9CA3AF));
    });
  });

  group('NOVA Group Color Mapping', () {
    test('Group 1 maps to correct color', () {
      expect(HealthScoring.mapNovaToColor(1), const Color(0xFF16A34A));
    });

    test('Group 2 maps to correct color', () {
      expect(HealthScoring.mapNovaToColor(2), const Color(0xFF22C55E));
    });

    test('Group 3 maps to correct color', () {
      expect(HealthScoring.mapNovaToColor(3), const Color(0xFFF97316));
    });

    test('Group 4 maps to correct color', () {
      expect(HealthScoring.mapNovaToColor(4), const Color(0xFFDC2626));
    });

    test('Unknown group maps to gray', () {
      expect(HealthScoring.mapNovaToColor(null), const Color(0xFF9CA3AF));
      expect(HealthScoring.mapNovaToColor(5), const Color(0xFF9CA3AF));
    });
  });

  group('Nutrient Classification - Sugar', () {
    test('Low sugar threshold', () {
      final result = HealthScoring.classifyNutrient(3.0, 'sugar');
      expect(result['status'], 'low');
      expect(result['arabicLabel'], ArabicStrings.low);
      expect(result['color'], const Color(0xFF16A34A));
    });

    test('Sugar at exact low boundary (5g)', () {
      final result = HealthScoring.classifyNutrient(5.0, 'sugar');
      expect(result['status'], 'low');
    });

    test('Moderate sugar', () {
      final result = HealthScoring.classifyNutrient(8.0, 'sugar');
      expect(result['status'], 'moderate');
      expect(result['arabicLabel'], ArabicStrings.moderate);
      expect(result['color'], const Color(0xFFEAB308));
    });

    test('High sugar', () {
      final result = HealthScoring.classifyNutrient(15.0, 'sugar');
      expect(result['status'], 'high');
      expect(result['arabicLabel'], ArabicStrings.high);
      expect(result['color'], const Color(0xFFDC2626));
    });

    test('Null sugar returns unknown', () {
      final result = HealthScoring.classifyNutrient(null, 'sugar');
      expect(result['status'], 'unknown');
      expect(result['arabicLabel'], ArabicStrings.unknown);
      expect(result['color'], const Color(0xFF9CA3AF));
    });
  });

  group('Nutrient Classification - Salt', () {
    test('Low salt', () {
      final result = HealthScoring.classifyNutrient(0.2, 'salt');
      expect(result['status'], 'low');
      expect(result['color'], const Color(0xFF16A34A));
    });

    test('Moderate salt', () {
      final result = HealthScoring.classifyNutrient(0.8, 'salt');
      expect(result['status'], 'moderate');
      expect(result['color'], const Color(0xFFEAB308));
    });

    test('High salt', () {
      final result = HealthScoring.classifyNutrient(2.0, 'salt');
      expect(result['status'], 'high');
      expect(result['color'], const Color(0xFFDC2626));
    });
  });

  group('Nutrient Classification - Saturated Fat', () {
    test('Low saturated fat', () {
      final result = HealthScoring.classifyNutrient(1.0, 'saturated-fat');
      expect(result['status'], 'low');
    });

    test('Moderate saturated fat', () {
      final result = HealthScoring.classifyNutrient(3.0, 'saturated-fat');
      expect(result['status'], 'moderate');
    });

    test('High saturated fat', () {
      final result = HealthScoring.classifyNutrient(7.0, 'saturated-fat');
      expect(result['status'], 'high');
    });
  });

  group('Nutrient Classification - Fiber (inverse)', () {
    test('High fiber is good', () {
      final result = HealthScoring.classifyNutrient(8.0, 'fiber');
      expect(result['status'], 'high');
      expect(result['color'], const Color(0xFF16A34A));
    });

    test('Moderate fiber', () {
      final result = HealthScoring.classifyNutrient(4.5, 'fiber');
      expect(result['status'], 'moderate');
      expect(result['color'], const Color(0xFFEAB308));
    });

    test('Low fiber is orange', () {
      final result = HealthScoring.classifyNutrient(2.0, 'fiber');
      expect(result['status'], 'low');
      expect(result['color'], const Color(0xFFF97316));
    });
  });

  group('Nutrient Classification - Protein (inverse)', () {
    test('High protein is good', () {
      final result = HealthScoring.classifyNutrient(12.0, 'protein');
      expect(result['status'], 'high');
      expect(result['color'], const Color(0xFF16A34A));
    });

    test('Moderate protein', () {
      final result = HealthScoring.classifyNutrient(7.0, 'protein');
      expect(result['status'], 'moderate');
    });

    test('Low protein', () {
      final result = HealthScoring.classifyNutrient(3.0, 'protein');
      expect(result['status'], 'low');
      expect(result['color'], const Color(0xFFF97316));
    });
  });

  group('Overall Label Computation', () {
    test('better_choice: Nutri A, NOVA 1, no high negatives', () {
      final product = ProductResult(
        barcode: '123',
        name: 'Test',
        brand: 'Test',
        nutriScore: 'A',
        ingredients: 'test',
        status: ProductStatus.GOOD,
        nutrients: {},
        novaGroup: 1,
        sugar: 3.0,
        salt: 0.2,
        saturatedFat: 1.0,
      );

      final result = HealthScoring.computeOverallLabel(product);
      expect(result['label'], 'better_choice');
      expect(result['arabicText'], ArabicStrings.betterChoice);
      expect(result['color'], const Color(0xFF16A34A));
    });

    test('limit: Nutri D', () {
      final product = ProductResult(
        barcode: '123',
        name: 'Test',
        brand: 'Test',
        nutriScore: 'D',
        ingredients: 'test',
        status: ProductStatus.BAD,
        nutrients: {},
        novaGroup: 2,
      );

      final result = HealthScoring.computeOverallLabel(product);
      expect(result['label'], 'limit');
      expect(result['arabicText'], ArabicStrings.limit);
      expect(result['color'], const Color(0xFFDC2626));
    });

    test('limit: NOVA 4', () {
      final product = ProductResult(
        barcode: '123',
        name: 'Test',
        brand: 'Test',
        nutriScore: 'B',
        ingredients: 'test',
        status: ProductStatus.GOOD,
        nutrients: {},
        novaGroup: 4,
      );

      final result = HealthScoring.computeOverallLabel(product);
      expect(result['label'], 'limit');
    });

    test('limit: two high negatives', () {
      final product = ProductResult(
        barcode: '123',
        name: 'Test',
        brand: 'Test',
        nutriScore: 'B',
        ingredients: 'test',
        status: ProductStatus.GOOD,
        nutrients: {},
        novaGroup: 2,
        sugar: 15.0, // high
        salt: 2.0,   // high
      );

      final result = HealthScoring.computeOverallLabel(product);
      expect(result['label'], 'limit');
    });

    test('ok_sometimes: Nutri C, NOVA 2, one high negative', () {
      final product = ProductResult(
        barcode: '123',
        name: 'Test',
        brand: 'Test',
        nutriScore: 'C',
        ingredients: 'test',
        status: ProductStatus.AVERAGE,
        nutrients: {},
        novaGroup: 2,
        sugar: 15.0, // high
      );

      final result = HealthScoring.computeOverallLabel(product);
      expect(result['label'], 'ok_sometimes');
      expect(result['arabicText'], ArabicStrings.okSometimes);
      expect(result['color'], const Color(0xFFEAB308));
    });

    test('unknown: missing all key data', () {
      final product = ProductResult(
        barcode: '123',
        name: 'Test',
        brand: 'Test',
        nutriScore: '?',
        ingredients: 'test',
        status: ProductStatus.UNKNOWN,
        nutrients: {},
      );

      final result = HealthScoring.computeOverallLabel(product);
      expect(result['label'], 'unknown');
      expect(result['arabicText'], ArabicStrings.unknown);
      expect(result['color'], const Color(0xFF9CA3AF));
    });
  });
}
