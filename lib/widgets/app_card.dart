import 'package:flutter/material.dart';

import '../core/theme.dart';

/// بطاقة مستديرة بظل ناعم.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.highlight = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final radius = BorderRadius.circular(22);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: radius,
        border: Border.all(
          color: highlight ? AppColors.gold : AppColors.border(context),
          width: highlight ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.28 : 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// عنوان قسم صغير.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
      child: Text(
        text,
        style: cairo(size: 16, weight: 700, color: AppColors.accent(context)),
      ),
    );
  }
}
