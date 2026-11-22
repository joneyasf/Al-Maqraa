import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/quran_data.dart';
import '../widgets/app_card.dart';
import '../widgets/app_scope.dart';
import '../widgets/gold_button.dart';
import '../widgets/islamic_pattern.dart';
import '../widgets/khatma_progress.dart';
import '../widgets/opening_banner.dart';
import '../widgets/session_countdown.dart';
import 'khatma_screen.dart';
import 'live_screen.dart';
import 'members_screen.dart';
import 'mushaf_screen.dart';
import 'settings_screen.dart';

/// الشاشة الرئيسية: الشريط الافتتاحي مثبّت فوق، وتحته العد التنازلي
/// وزر الدخول وبطاقات الليلة والختمة والحضور والدعاء.
/// كل الأرقام هنا تمر من AppState فتظهر مشرقية ٠١٢٣ افتراضيًا.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context).app;
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        final tonightSurah = surahForPage(app.tonightStartPage);
        return Column(
          children: [
            const OpeningBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'المقرأة الليلية',
                            style: amiri(
                              size: 26,
                              bold: true,
                              color: AppColors.accent(context),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'الإعدادات',
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          ),
                          icon: Icon(
                            Icons.settings_rounded,
                            color: AppColors.mutedText(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'كل ليلة ${app.fmtText('10:30')} – ${app.fmtText('11:00')} م بتوقيت القاهرة',
                      style: cairo(
                        size: 14,
                        color: AppColors.mutedText(context),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const SessionCountdown(),
                    const SizedBox(height: 16),
                    GoldButton(
                      label: 'ادخل المقرأة الآن',
                      icon: Icons.mic_rounded,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LiveScreen(),
                        ),
                      ),
                    ),
                    const SectionTitle('هنقرأ الليلة'),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.menu_book_rounded,
                                color: AppColors.gold,
                                size: 26,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'الجزء ${app.fmt(app.currentJuz)} — سورة ${tonightSurah.name}',
                                  style: cairo(
                                    size: 18,
                                    weight: 800,
                                    color: AppColors.text(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'من صفحة ${app.fmt(app.tonightStartPage)} إلى صفحة ${app.fmt(app.tonightEndPage)}',
                            style: cairo(
                              size: 15,
                              color: AppColors.mutedText(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'الشيخ يقود الجلسة، والصوت هو الأساس، والفيديو للشيخ فقط',
                            style: cairo(
                              size: 13,
                              color: AppColors.mutedText(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SectionTitle('تقدّم الختمة'),
                    AppCard(
                      child: KhatmaProgress(
                        completed: app.completedJuzCount,
                        total: 30,
                        currentJuz: app.currentJuz,
                        eastern: app.easternNumerals,
                      ),
                    ),
                    const SectionTitle('حضورك'),
                    Row(
                      children: [
                        Expanded(
                          child: AppCard(
                            child: Column(
                              children: [
                                Text(
                                  app.fmt(app.attendanceStreak),
                                  style: cairo(
                                    size: 30,
                                    weight: 800,
                                    color: AppColors.gold,
                                  ),
                                ),
                                Text(
                                  'ليلة متتالية',
                                  style: cairo(
                                    size: 13,
                                    color: AppColors.mutedText(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppCard(
                            child: Column(
                              children: [
                                Text(
                                  app.fmt(app.totalPagesRead),
                                  style: cairo(
                                    size: 30,
                                    weight: 800,
                                    color: AppColors.gold,
                                  ),
                                ),
                                Text(
                                  'صفحة قرأتها',
                                  style: cairo(
                                    size: 13,
                                    color: AppColors.mutedText(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SectionTitle('وصول سريع'),
                    Row(
                      children: [
                        Expanded(
                          child: _quickButton(
                            context,
                            icon: Icons.menu_book_rounded,
                            label: 'المصحف',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MushafScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _quickButton(
                            context,
                            icon: Icons.group_rounded,
                            label: 'الأعضاء',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MembersScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _quickButton(
                            context,
                            icon: Icons.check_circle_rounded,
                            label: 'الختمة',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const KhatmaScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SectionTitle('دعاء لوالدي'),
                    AppCard(
                      highlight: true,
                      child: Column(
                        children: [
                          const Center(
                            child: OrnamentDivider(color: AppColors.gold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            kParentsDua,
                            textAlign: TextAlign.center,
                            style: amiri(
                              size: 19,
                              color: AppColors.text(context),
                              height: 1.9,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 140,
                            height: 44,
                            child: GoldButton(
                              label: 'آمين',
                              fontSize: 17,
                              height: 44,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'تقبّل الله منا ومنكم',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _quickButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: AppColors.gold, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: cairo(
              size: 15,
              weight: 700,
              color: AppColors.text(context),
            ),
          ),
        ],
      ),
    );
  }
}
