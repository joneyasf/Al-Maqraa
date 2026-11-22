import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/notification_service.dart';
import '../widgets/app_card.dart';
import '../widgets/app_scope.dart';

/// الإعدادات.
/// قسم الأرقام هو الأهم هنا: الافتراضي مشرقي ٠١٢٣،
/// والإنجليزي 123 خيار ثانوي فقط.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context).app;
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'الإعدادات',
              style: amiri(size: 24, bold: true),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الأرقام',
                        style: cairo(
                          size: 17,
                          weight: 800,
                          color: AppColors.text(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الافتراضي عند أول فتح للتطبيق: مشرقية ٠١٢٣',
                        style: cairo(
                          size: 13,
                          color: AppColors.mutedText(context),
                        ),
                      ),
                      RadioListTile<bool>(
                        title: Text(
                          'الأرقام المشرقية ٠١٢٣٤٥٦٧٨٩ (الافتراضي)',
                          style: cairo(size: 15, weight: 700),
                        ),
                        value: true,
                        groupValue: app.easternNumerals,
                        onChanged: (v) {
                          if (v != null) app.setEasternNumerals(v);
                        },
                      ),
                      RadioListTile<bool>(
                        title: Text(
                          'الأرقام الإنجليزية 1234567890',
                          style: cairo(size: 15, weight: 700),
                        ),
                        value: false,
                        groupValue: app.easternNumerals,
                        onChanged: (v) {
                          if (v != null) app.setEasternNumerals(v);
                        },
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'مثال: صفحة ${app.fmt(122)} — الجزء ${app.fmt(7)} — آية ${app.fmt(82)} — الساعة ${app.fmtText('10:30')} م',
                          textAlign: TextAlign.center,
                          style: cairo(
                            size: 15,
                            weight: 700,
                            color: AppColors.text(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اسمك في المقرأة',
                        style: cairo(
                          size: 17,
                          weight: 800,
                          color: AppColors.text(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: TextEditingController(text: app.userName),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'الاسم الذي يظهر للأعضاء',
                        ),
                        onSubmitted: app.setUserName,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text(
                          'الوضع الداكن',
                          style: cairo(size: 15, weight: 700),
                        ),
                        value: app.darkMode,
                        onChanged: app.setDarkMode,
                      ),
                      SwitchListTile(
                        title: Text(
                          'تذكير قبل المقرأة بـ ١٥ دقيقة (١٠:١٥ م)',
                          style: cairo(size: 15, weight: 700),
                        ),
                        value: app.reminderEnabled,
                        onChanged: (v) async {
                          app.setReminderEnabled(v);
                          if (v) {
                            await NotificationService.scheduleDailyReminder();
                          } else {
                            await NotificationService.cancelReminder();
                          }
                        },
                      ),
                      ListTile(
                        title: Text(
                          'حجم خط المصحف',
                          style: cairo(size: 15, weight: 700),
                        ),
                        subtitle: Slider(
                          value: app.fontScale,
                          min: 0.85,
                          max: 1.6,
                          divisions: 15,
                          label: '${app.fmt((app.fontScale * 100).round())}٪',
                          onChanged: app.setFontScale,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    children: [
                      Text(
                        'لوجه الله — المقرأة الليلية',
                        style: amiri(
                          size: 20,
                          bold: true,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'الإصدار 1.0.0 — صدقة جارية، مجاني، مفتوح المصدر، بدون إعلانات وبدون حسابات.',
                        textAlign: TextAlign.center,
                        style: cairo(size: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'المشروع على GitHub: joneyasf/maqraa',
                        textAlign: TextAlign.center,
                        style: cairo(
                          size: 13,
                          color: AppColors.mutedText(context),
                        ),
                      ),
                    ],
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
