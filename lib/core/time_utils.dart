import 'arabic_utils.dart';
import 'constants.dart';

/// حالة المقرأة بالنسبة لموعد الليلة.
enum SessionPhase { before, live, after }

/// نتيجة حساب موعد المقرأة.
class SessionClock {
  const SessionClock({
    required this.phase,
    required this.remaining,
    required this.startsAt,
  });

  final SessionPhase phase;
  final Duration remaining;
  final DateTime startsAt;
}

/// رقم برقمين: 5 -> "05".
String two(int value) => value.toString().padLeft(2, '0');

/// يحسب حالة المقرأة الآن.
/// يستخدم توقيت الجهاز المحلي (محمد في مصر، جهازه بتوقيت القاهرة).
SessionClock sessionClock([DateTime? now]) {
  final current = now ?? DateTime.now();
  final todayStart = DateTime(
    current.year,
    current.month,
    current.day,
    kStartHour,
    kStartMinute,
  );
  final todayEnd = DateTime(
    current.year,
    current.month,
    current.day,
    kEndHour,
    kEndMinute,
  );
  if (current.isBefore(todayStart)) {
    return SessionClock(
      phase: SessionPhase.before,
      remaining: todayStart.difference(current),
      startsAt: todayStart,
    );
  }
  if (current.isBefore(todayEnd)) {
    return SessionClock(
      phase: SessionPhase.live,
      remaining: todayEnd.difference(current),
      startsAt: todayStart,
    );
  }
  final tomorrowStart = todayStart.add(const Duration(days: 1));
  return SessionClock(
    phase: SessionPhase.after,
    remaining: tomorrowStart.difference(current),
    startsAt: tomorrowStart,
  );
}

/// ينسّق مدة على شكل 02:15:30 مع تحويل الأرقام حسب [eastern].
/// الافتراضي عند محمد: مشرقي، فتظهر ٠٢:١٥:٣٠.
String formatDuration(Duration duration, bool eastern) {
  final total = duration.inSeconds;
  final h = total ~/ 3600;
  final m = (total % 3600) ~/ 60;
  final s = total % 60;
  return formatDigits('${two(h)}:${two(m)}:${two(s)}', eastern);
}

/// موعد المقرأة الليلة كنص 12 ساعة: "١٠:٣٠ م" بالمشرقي أو "10:30 م" بالإنجليزي.
String sessionTimeText(bool eastern) {
  final hour12 = kStartHour > 12 ? kStartHour - 12 : kStartHour;
  return formatDigits('$hour12:${two(kStartMinute)} م', eastern);
}
