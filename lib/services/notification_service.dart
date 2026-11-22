import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// تذكير يومي قبل المقرأة بـ 15 دقيقة (22:15).
/// كل العمليات محمية بـ try/catch حتى لا يتعطل التطبيق أبدًا بسبب الإشعارات.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    try {
      tzdata.initializeTimeZones();
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const settings = InitializationSettings(android: android);
      await _plugin.initialize(settings);
      _initialized = true;
    } catch (_) {
      _initialized = false;
    }
  }

  static Future<void> scheduleDailyReminder() async {
    if (!_initialized) return;
    try {
      await _plugin.zonedSchedule(
        1,
        'المقرأة الليلية — لوجه الله',
        'تبقى 15 دقيقة على المقرأة، جهّز مصحفك',
        _nextReminderTime(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'maqraa_reminder',
            'تذكير المقرأة',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {}
  }

  static tz.TZDateTime _nextReminderTime() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 22, 15);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<void> cancelReminder() async {
    try {
      await _plugin.cancel(1);
    } catch (_) {}
  }
}
