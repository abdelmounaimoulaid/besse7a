import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/models/product_model.dart';
import 'package:mobile_app/widgets/health_overview_section.dart';
import 'package:mobile_app/utils/arabic_strings.dart';

class ProductResultScreen extends StatefulWidget {
  final ProductResult product;

  const ProductResultScreen({super.key, required this.product});

  @override
  State<ProductResultScreen> createState() => _ProductResultScreenState();
}

class _ProductResultScreenState extends State<ProductResultScreen> {
  late ProductResult product;
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    product = widget.product;
    if (product.productWeight != null) {
      _weightController.text = product.productWeight!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _updateWeight(String value) {
    if (value.isEmpty) return;
    final newWeight = double.tryParse(value);
    if (newWeight != null) {
      setState(() {
        product = product.copyWith(productWeight: newWeight);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(product.status);
    final statusIcon = _getStatusIcon(product.status);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black), // Forward for RTL back
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(ArabicStrings.healthOverview, style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
            // Product Image
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[100],
              child: product.image != null
                  ? Image.network(product.image!, fit: BoxFit.contain)
                  : const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
            ),
            
            // Result Card
            Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5)),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Header
                  Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        _getStatusArabic(product.status),
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Product Info
                  Text(
                    product.name,
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brand,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Nutri-Score Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: statusColor, width: 4),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            product.nutriScore.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ArabicStrings.nutriScore,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ArabicStrings.basedOnQuality,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  

                  const SizedBox(height: 24),

                  // Health Overview Section (Arabic + RTL)
                  HealthOverviewSection(product: product),
                  
                  const SizedBox(height: 24),
                  
                  const SizedBox(height: 32),
                  
                  // Nutrition Facts
                  Text(
                    ArabicStrings.nutritionFacts,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: product.nutrients.entries.where((e) => e.value != 'N/A').isEmpty 
                    ? Center(
                        child: Text(
                          'لا توجد معلومات غذائية',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.start,
                      children: product.nutrients.entries
                          .where((entry) => entry.value != 'N/A')
                          .map((entry) {
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 48 - 32 - 16) / 2, // Half width minus spacing
                          child: _NutrientItem(
                            name: entry.key,
                            value: entry.value,
                            icon: _getNutrientIcon(entry.key),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Alternatives Section (only for poor scores)
                  if (product.status == ProductStatus.BAD || product.status == ProductStatus.AVERAGE) ...[
                    const SizedBox(height: 32),
                    Text(
                      ArabicStrings.betterAlternatives,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _AlternativesSection(
                      category: product.category,
                      currentNutriScore: product.nutriScore,
                    ),
                   ],
                 ],
               ),
             ),
           ],
         ),
        ),
      ),
    );
  }

  IconData _getNutrientIcon(String nutrient) {
    if (nutrient == ArabicStrings.energy) return Icons.bolt;
    if (nutrient == ArabicStrings.fat) return Icons.water_drop;
    if (nutrient == ArabicStrings.saturatedFat) return Icons.opacity;
    if (nutrient == ArabicStrings.carbohydrates) return Icons.grain;
    if (nutrient == ArabicStrings.sugar) return Icons.cake;
    if (nutrient == ArabicStrings.fiber) return Icons.eco;
    if (nutrient == ArabicStrings.protein) return Icons.fitness_center;
    if (nutrient == ArabicStrings.salt) return Icons.science;
    return Icons.info;
  }


  Color _getStatusColor(ProductStatus status) {
    switch (status) {
      case ProductStatus.GOOD: return const Color(0xFF22C55E);
      case ProductStatus.AVERAGE: return const Color(0xFFEAB308);
      case ProductStatus.BAD: return const Color(0xFFEF4444);
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(ProductStatus status) {
    switch (status) {
      case ProductStatus.GOOD: return Icons.check_circle;
      case ProductStatus.AVERAGE: return Icons.warning_amber_rounded;
      case ProductStatus.BAD: return Icons.dangerous;
      default: return Icons.help_outline;
    }
  }

  String _getStatusArabic(ProductStatus status) {
    switch (status) {
      case ProductStatus.GOOD: return ArabicStrings.statusGood;
      case ProductStatus.AVERAGE: return ArabicStrings.statusAverage;
      case ProductStatus.BAD: return ArabicStrings.statusBad;
      default: return ArabicStrings.unknown;
    }
  }
}

// Nutrient Item Widget
class _NutrientItem extends StatelessWidget {
  final String name;
  final String value;
  final IconData icon;

  const _NutrientItem({
    required this.name,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF059669)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Alternatives Section Widget
class _AlternativesSection extends StatefulWidget {
  final String? category;
  final String currentNutriScore;

  const _AlternativesSection({
    required this.category,
    required this.currentNutriScore,
  });

  @override
  State<_AlternativesSection> createState() => _AlternativesSectionState();
}

class _AlternativesSectionState extends State<_AlternativesSection> {
  List<ProductResult>? _alternatives;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAlternatives();
  }

  Future<void> _fetchAlternatives() async {
    try {
      // For now, show a placeholder message
      // In a full implementation, we'd call the OpenFoodFacts search API
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _alternatives = []; // Empty for now - would fetch from API
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = ArabicStrings.failedToLoadAlternatives;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: Color(0xFF059669)),
        ),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _error!,
          style: GoogleFonts.outfit(color: Colors.red[700]),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_alternatives == null || _alternatives!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(Icons.shopping_basket_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              ArabicStrings.noAlternatives,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              ArabicStrings.scanAnother,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _alternatives!.map((alt) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: alt.image != null
                    ? Image.network(alt.image!, width: 60, height: 60, fit: BoxFit.cover)
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alt.name,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      alt.brand,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  alt.nutriScore,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF22C55E),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

