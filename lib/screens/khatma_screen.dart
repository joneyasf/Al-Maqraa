import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_scope.dart';
import '../widgets/gold_button.dart';
import '../widgets/khatma_progress.dart';

/// تتبّع الختمة: 30 جزءًا، كل جزء يُعلَّم عند إتمامه.
/// كل الأرقام مشرقية افتراضيًا من AppState.
class KhatmaScreen extends StatelessWidget {
  const KhatmaScreen({super.key});

  void _newKhatmaDialog(BuildContext context) {
    final app = AppScope.read(context).app;
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'ابدأ ختمة جديدة واهدها لميت',
            style: cairo(size: 18, weight: 800),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'اسم الميت (اختياري)',
              hintText: 'مثال: والدي رحمه الله',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                Navigator.of(dialogContext).pop();
                app.startNewKhatma(
                  name.isEmpty ? 'والد صاحب التطبيق رحمه الله' : name,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'بدأت ختمة جديدة، تقبّل الله',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              child: const Text('ابدأ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context).app;
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'الختمة',
              style: amiri(size: 24, bold: true),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  child: KhatmaProgress(
                    completed: app.completedJuzCount,
                    total: 30,
                    currentJuz: app.currentJuz,
                    eastern: app.easternNumerals,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'اضغط على الجزء عند إتمامه',
                  style: cairo(
                    size: 14,
                    color: AppColors.mutedText(context),
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, i) {
                    final juz = i + 1;
                    final done = app.completedJuz.contains(juz);
                    final current = app.currentJuz == juz;
                    return InkWell(
                      onTap: () => app.completeJuz(juz),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: done
                              ? AppColors.gold
                              : AppColors.card(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: current
                                ? AppColors.gold
                                : AppColors.border(context),
                            width: current ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (done)
                              const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: AppColors.deepGreen,
                              ),
                            Text(
                              'جزء',
                              style: cairo(
                                size: 11,
                                color: done
                                    ? AppColors.deepGreen
                                    : AppColors.mutedText(context),
                              ),
                            ),
                            Text(
                              app.fmt(juz),
                              style: cairo(
                                size: 19,
                                weight: 800,
                                color: done
                                    ? AppColors.deepGreen
                                    : AppColors.text(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                GoldButton(
                  label: 'ابدأ ختمة جديدة واهدها لميت',
                  icon: Icons.favorite_rounded,
                  onPressed: () => _newKhatmaDialog(context),
                ),
                const SizedBox(height: 18),
                Text(
                  'ختمات مكتملة',
                  style: cairo(
                    size: 16,
                    weight: 700,
                    color: AppColors.accent(context),
                  ),
                ),
                const SizedBox(height: 8),
                for (final k in app.completedKhatmas)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ختمة مكتملة',
                                  style: cairo(
                                    size: 16,
                                    weight: 800,
                                    color: AppColors.text(context),
                                  ),
                                ),
                                Text(
                                  'أُهديت إلى: ${k['giftedTo']}',
                                  style: cairo(size: 13),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            k['date'] ?? '',
                            style: cairo(
                              size: 13,
                              color: AppColors.mutedText(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                AppCard(
                  child: Text(
                    'الختمات الحالية تُهدى لوالد صاحب التطبيق رحمه الله، ما لم تختر غير ذلك.',
                    textAlign: TextAlign.center,
                    style: cairo(size: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
