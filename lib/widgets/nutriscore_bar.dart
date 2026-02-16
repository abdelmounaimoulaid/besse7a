import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NutriScoreBar extends StatelessWidget {
  final String score; // 'A', 'B', 'C', 'D', 'E' or '?'

  const NutriScoreBar({
    Key? key,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine active index
    final cleanScore = score.toUpperCase();
    final letters = ['A', 'B', 'C', 'D', 'E'];
    int activeIndex = letters.indexOf(cleanScore);

    // Nutri-Score is strictly LTR (A -> E)
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'NUTRI-SCORE',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F2937),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                final isActive = index == activeIndex;
                final color = _getColor(index);
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  width: isActive ? 55 : 35,
                  height: isActive ? 55 : 35,
                  margin: EdgeInsets.symmetric(horizontal: isActive ? 4 : 1),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle, // Rounded style like bubbles
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                    border: isActive
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letters[index],
                    style: GoogleFonts.poppins(
                      fontSize: isActive ? 24 : 16,
                      fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                      color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(int index) {
    switch (index) {
      case 0: return const Color(0xFF008148); // A
      case 1: return const Color(0xFF85BB2F); // B
      case 2: return const Color(0xFFFECB02); // C
      case 3: return const Color(0xFFEE8100); // D
      case 4: return const Color(0xFFE63E11); // E
      default: return Colors.grey;
    }
  }
}
