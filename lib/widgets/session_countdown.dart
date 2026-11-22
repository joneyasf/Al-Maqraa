import 'dart:async';

import 'package:flutter/material.dart';

import '../core/arabic_utils.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/time_utils.dart';
import 'app_card.dart';
import 'app_scope.dart';

/// عدّاد تنازلي لموعد المقرأة (22:30 بتوقيت القاهرة).
class SessionCountdown extends StatefulWidget {
  const SessionCountdown({super.key, this.compact = false});

  final bool compact;

  @override
  State<SessionCountdown> createState() => _SessionCountdownState();
}

class _SessionCountdownState extends State<SessionCountdown> {
  Timer? _timer;
  SessionClock _clock = sessionClock();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _clock = sessionClock());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context).app;
    final eastern = app.easternNumerals;
    final live = _clock.phase == SessionPhase.live;
    final label = switch (_clock.phase) {
      SessionPhase.before => 'تبدأ المقرأة الليلة بعد',
      SessionPhase.live => 'المقرأة جارية الآن — تنتهي بعد',
      SessionPhase.after => 'المقرأة القادمة بعد',
    };
    final time = formatDuration(_clock.remaining, eastern);
    final range =
        'كل ليلة ${formatDigits('$kStartHour:$kStartMinute', eastern)} – ${formatDigits('$kEndHour:${two(kEndMinute)}', eastern)} بتوقيت القاهرة';

    if (widget.compact) {
      return Row(
        children: [
          Icon(live ? Icons.fiber_manual_record : Icons.schedule_rounded,
              size: 18, color: live ? Colors.redAccent : AppColors.accent(context)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label  $time',
              style: cairo(size: 14, weight: 700, color: AppColors.text(context)),
            ),
          ),
        ],
      );
    }

    return AppCard(
      highlight: live,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: cairo(size: 15, weight: 700, color: AppColors.mutedText(context)),
          ),
          const SizedBox(height: 6),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: cairo(size: 44, weight: 800, color: AppColors.accent(context), height: 1.15),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            range,
            textAlign: TextAlign.center,
            style: cairo(size: 13, color: AppColors.mutedText(context)),
          ),
        ],
      ),
    );
  }
}
