import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/models/product_model.dart';
import 'package:mobile_app/utils/arabic_strings.dart';
import 'package:mobile_app/utils/health_scoring.dart';
import 'package:mobile_app/widgets/nutriscore_bar.dart';

// RTL-aware health overview section for Arabic UI
// Displays Nutri-Score, NOVA, nutrients, and warnings from Open Food Facts

class HealthOverviewSection extends StatelessWidget {
  final ProductResult product;

  const HealthOverviewSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8), // Just a small spacer if needed, or remove completely if cleaner.
          
          const SizedBox(height: 24),
          
          // Report List (Nutrients & Additives)
          // 1. Additives
          // 52: Report List (Nutrients & Additives)
          // 53: 1. Additives (Yuka Style)
          if (product.additivesCount != null && product.additivesCount! > 0) ...[
            _buildReportItem(
              title: ArabicStrings.additives,
              value: '${product.additivesCount}',
              unit: '',
              description: 'يحتوي على ${product.additivesCount} مضافات',
              color: const Color(0xFFF97316),
              icon: Icons.science,
            ),
            // Expanded List
            Container(
              margin: const EdgeInsets.only(bottom: 24, right: 16, left: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.additives.map((additive) {
                  final risk = _getAdditiveRisk(additive);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: risk['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              additive,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              risk['label'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ] else if (product.additivesCount == 0)
            _buildReportItem(
              title: ArabicStrings.additives,
              value: '0',
              unit: '',
              description: 'خالي من المضافات',
              color: const Color(0xFF16A34A),
              icon: Icons.check_circle_outline,
            ),

          // 2. Nutrients (If exist)
          if (product.sugar != null) _buildNutrientReportItem('sugar', product.sugar!, ArabicStrings.sugar),
          if (product.salt != null) _buildNutrientReportItem('salt', product.salt!, ArabicStrings.salt),
          if (product.saturatedFat != null) _buildNutrientReportItem('saturated-fat', product.saturatedFat!, ArabicStrings.saturatedFat),
          if (product.fiber != null) _buildNutrientReportItem('fiber', product.fiber!, ArabicStrings.fiber),
          if (product.protein != null) _buildNutrientReportItem('protein', product.protein!, ArabicStrings.protein),
          
          // 3. Allergens (If exist)
          if (product.allergens.isNotEmpty)
             _buildReportItem(
              title: ArabicStrings.allergens,
              value: '${product.allergens.length}',
              unit: '',
              description: product.allergens.join(', ').replaceAll('en:', '').replaceAll('-', ' '),
              color: const Color(0xFFDC2626),
              icon: Icons.warning_amber_rounded,
            ),
        ],
      ),
    );
  }

  Widget _buildNutrientReportItem(String type, double value, String title) {
    final eval = HealthScoring.getNutrientEvaluation(type, value, false);
    return _buildReportItem(
      title: title,
      value: '$value',
      unit: 'g',
      description: eval['label'],
      color: eval['color'],
      icon: eval['icon'],
    );
  }

  Widget _buildReportItem({
    required String title,
    required String value,
    required String unit,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)), // Divider
      ),
      child: Row(
        children: [
          // Icon
          Icon(icon, color: Colors.grey[600], size: 24),
          const SizedBox(width: 16),
          
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Value & Dot
          Row(
            children: [
              Text(
                '$value$unit',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.expand_more, color: Colors.grey[400], size: 20), // Placeholder chevron
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard({required String title, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getAdditiveRisk(String additive) {
    // Basic heuristic based on E-number ranges
    // This is NOT medical advice, just a general categorization for demo purposes
    String code = additive.replaceAll(RegExp(r'[^0-9]'), '');
    int? number = int.tryParse(code);
    
    String label = 'مضاف غذائي'; // Food additive
    Color color = Colors.orange;

    if (number != null) {
      if (number >= 100 && number < 200) {
        label = 'ملون غذائي'; // Color
        color = const Color(0xFFF97316); // Orange
      } else if (number >= 200 && number < 300) {
        label = 'مادة حافظة'; // Preservative
        color = const Color(0xFFDC2626); // Red
      } else if (number >= 300 && number < 400) {
        label = 'مضاد للأكسدة'; // Antioxidant
        color = const Color(0xFF16A34A); // Green
      } else if (number >= 400 && number < 500) {
        label = 'مادة قوام'; // Texture
        color = const Color(0xFF22C55E); // Green
      } else if (number >= 620 && number < 636) {
        label = 'معزز نكهة'; // Flavor enhancer
        color = const Color(0xFFDC2626); // Red
      } else if (number >= 900 && number < 1000) {
        label = 'محلي صناعي / مادة تلميع'; // Sweetener / Glazing
        color = const Color(0xFFEAB308); // Yellow
      }
    }
    
    return {'color': color, 'label': label};
  }
}
