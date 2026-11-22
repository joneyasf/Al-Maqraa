import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'app_card.dart';
import 'app_scope.dart';

/// طابور الدور في الجلسة: القارئ الحالي والتاليان.
/// كل الأرقام هنا تمر من AppState فتظهر مشرقية افتراضيًا.
class TurnQueue extends StatelessWidget {
  const TurnQueue({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final live = scope.live;
    final app = scope.app;
    return AnimatedBuilder(
      animation: Listenable.merge([app, live]),
      builder: (context, _) {
        final current = live.currentReader;
        final next = live.nextReader;
        final after = live.afterNextReader;
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _row(
                context,
                icon: Icons.mic_rounded,
                label: 'يقرأ الآن',
                name: current.name,
                highlight: true,
                order: 'الدور ${app.fmtText('1')}',
              ),
              const SizedBox(height: 10),
              _row(
                context,
                icon: Icons.hourglass_top_rounded,
                label: 'التالي',
                name: next.name,
                highlight: false,
                order: 'الدور ${app.fmtText('2')}',
              ),
              const SizedBox(height: 10),
              _row(
                context,
                icon: Icons.schedule_rounded,
                label: 'بعده',
                name: after.name,
                highlight: false,
                order: 'الدور ${app.fmtText('3')}',
              ),
              if (live.isSheikh) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: live.advanceTurn,
                    icon: const Icon(Icons.skip_next_rounded),
                    label: Text(
                      'انقل الدور للتالي',
                      style: cairo(size: 15, weight: 700),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _row(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String name,
    required bool highlight,
    required String order,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.gold.withValues(alpha: 0.16)
            : AppColors.background(context).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight
              ? AppColors.gold
              : AppColors.border(context),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent(context), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: cairo(
                    size: 12,
                    color: AppColors.mutedText(context),
                  ),
                ),
                Text(
                  name,
                  style: cairo(
                    size: 17,
                    weight: 800,
                    color: AppColors.text(context),
                  ),
                ),
              ],
            ),
          ),
          Text(
            order,
            style: cairo(size: 13, weight: 700, color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}
