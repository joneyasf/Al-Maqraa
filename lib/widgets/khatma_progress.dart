import 'package:flutter/material.dart';

import '../core/arabic_utils.dart';
import '../core/theme.dart';

/// شريط تقدم الختمة الذهبي.
/// كل الأرقام تظهر مشرقية افتراضيًا حسب اختيار المستخدم.
class KhatmaProgress extends StatelessWidget {
  const KhatmaProgress({
    super.key,
    required this.completed,
    required this.total,
    required this.currentJuz,
    required this.eastern,
  });

  final int completed;
  final int total;
  final int currentJuz;
  final bool eastern;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    final percent = formatPercent(progress * 100, eastern);
    final parts = formatDigits('$completed من $total', eastern);
    final current = formatDigits('الجزء $currentJuz', eastern);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الختمة الحالية: $current',
              style: cairo(size: 15, weight: 700, color: AppColors.text(context)),
            ),
            Text(
              percent,
              style: cairo(size: 16, weight: 800, color: AppColors.gold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: AppColors.border(context),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'أكملت $parts أجزاء',
          textAlign: TextAlign.center,
          style: cairo(size: 13, color: AppColors.mutedText(context)),
        ),
      ],
    );
  }
}
