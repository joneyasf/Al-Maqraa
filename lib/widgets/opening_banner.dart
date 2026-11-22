import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import 'islamic_pattern.dart';

/// الشريط الافتتاحي المثبّت أعلى الشاشة الرئيسية.
/// النص يأتي من الثابت kOpeningPhrase ولا يُعدَّل أبدًا.
class OpeningBanner extends StatelessWidget {
  const OpeningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.deepGreen,
        border: Border(
          bottom: BorderSide(color: AppColors.gold.withValues(alpha: 0.85), width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: IslamicPatternPainter(
                color: AppColors.gold.withValues(alpha: 0.10),
                cell: 52,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              child: Center(
                child: Text(
                  kOpeningPhrase,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: amiri(size: 30, bold: true, color: AppColors.gold, height: 1.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
