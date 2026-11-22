import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../core/time_utils.dart';
import '../state/live_controller.dart';
import '../services/jitsi_service.dart';
import '../widgets/app_card.dart';
import '../widgets/app_scope.dart';
import '../widgets/gold_button.dart';
import '../widgets/turn_queue.dart';
import 'mushaf_screen.dart';

/// شاشة المقرأة الحية.
/// الصوت مفتوح افتراضيًا، والفيديو مغلق افتراضيًا ما عدا الشيخ.
/// الدخول يفتح غرفة Jitsi (meet.jit.si) — الصوت والصورة يتمّان داخل
/// الغرفة، وهنا نتابع الدور والصفحة الحالية والوقت.
class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final JitsiService _jitsi = JitsiService();
  bool _joining = false;
  bool _joinFailed = false;

  Future<void> _join() async {
    final scope = AppScope.read(context);
    setState(() {
      _joining = true;
      _joinFailed = false;
    });
    final ok = await _jitsi.joinRoom(
      displayName: scope.app.userName,
      videoOn: scope.live.videoOn,
    );
    if (!mounted) return;
    setState(() => _joining = false);
    if (ok) {
      scope.live.join();
    } else {
      setState(() => _joinFailed = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذّر الاتصال بالغرفة — تحقق من الإنترنت وحاول مرة أخرى',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Future<void> _leave() async {
    await _jitsi.hangUp();
    if (!mounted) return;
    AppScope.read(context).live.leave();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'تقبّل الله',
            textAlign: TextAlign.center,
            style: cairo(size: 20, weight: 800),
          ),
          content: Text(
            kParentsDua,
            textAlign: TextAlign.center,
            style: amiri(size: 19, height: 1.9),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'آمين',
                  style: cairo(size: 18, weight: 800, color: AppColors.gold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final app = scope.app;
    final live = scope.live;
    return AnimatedBuilder(
      animation: Listenable.merge([app, live]),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'المقرأة الليلية',
              style: amiri(size: 24, bold: true),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  highlight: live.inSession,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            live.inSession
                                ? Icons.fiber_manual_record
                                : Icons.schedule_rounded,
                            color: live.inSession
                                ? Colors.redAccent
                                : AppColors.gold,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              live.inSession
                                  ? 'متصل الآن — غرفة Jitsi مفتوحة'
                                  : 'نقرأ الآن: سورة ${live.currentSurah}، آية ${app.fmt(live.currentAyah)}، صفحة ${app.fmt(live.currentPage)}',
                              style: cairo(
                                size: 15,
                                weight: 700,
                                color: AppColors.text(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (live.inSession) ...[
                        const SizedBox(height: 8),
                        Text(
                          'مضى من الجلسة: ${formatDuration(live.elapsed, app.easternNumerals)}',
                          style: cairo(
                            size: 16,
                            weight: 800,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 46,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              app.setLastPage(live.currentPage);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const MushafScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.menu_book_rounded),
                            label: const Text('فتح المصحف على الصفحة الحالية'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_joinFailed)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: AppCard(
                      child: Text(
                        'تعذّر الاتصال — يمكنك متابعة القراءة من المصحف، أو فتح الغرفة من المتصفح على الرابط: meet.jit.si/maqraa-liwajhullah-daily',
                        style: cairo(size: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                _sheikhTile(context, live),
                const SizedBox(height: 14),
                Text(
                  'الأعضاء (${app.fmt(live.members.length)})',
                  style: cairo(
                    size: 16,
                    weight: 700,
                    color: AppColors.accent(context),
                  ),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: live.members.length,
                  itemBuilder: (context, i) {
                    final m = live.members[i];
                    final isCurrent = i == live.currentReaderIndex;
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.card(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.gold
                              : AppColors.border(context),
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: m.isSheikh
                                ? AppColors.gold
                                : AppColors.emerald,
                            child: Text(
                              m.name.characters.first,
                              style: cairo(
                                size: 18,
                                weight: 800,
                                color: m.isSheikh
                                    ? AppColors.deepGreen
                                    : Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            m.name,
                            overflow: TextOverflow.ellipsis,
                            style: cairo(
                              size: 13,
                              weight: 700,
                              color: AppColors.text(context),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                m.micOn
                                    ? Icons.mic_rounded
                                    : Icons.mic_off_rounded,
                                size: 15,
                                color: m.micOn
                                    ? AppColors.emeraldLight
                                    : Colors.redAccent,
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                m.videoOn
                                    ? Icons.videocam_rounded
                                    : Icons.videocam_off_rounded,
                                size: 15,
                                color: AppColors.mutedText(context),
                              ),
                              if (m.handRaised) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.pan_tool_rounded,
                                  size: 15,
                                  color: AppColors.gold,
                                ),
                              ],
                            ],
                          ),
                          if (isCurrent)
                            Text(
                              'يقرأ الآن',
                              style: cairo(
                                size: 11,
                                weight: 800,
                                color: AppColors.gold,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                const TurnQueue(),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إعدادات الدخول',
                        style: cairo(
                          size: 16,
                          weight: 800,
                          color: AppColors.text(context),
                        ),
                      ),
                      SwitchListTile(
                        title: Text(
                          'الميكروفون مفتوح',
                          style: cairo(size: 15),
                        ),
                        value: live.micOn,
                        onChanged: (_) => live.toggleMic(),
                      ),
                      SwitchListTile(
                        title: Text(
                          'الكاميرا مفتوحة (مغلقة افتراضيًا)',
                          style: cairo(size: 15),
                        ),
                        value: live.videoOn,
                        onChanged: (_) => live.toggleVideo(),
                      ),
                      SwitchListTile(
                        title: Text(
                          'وضع الشيخ (تجريبي)',
                          style: cairo(size: 15),
                        ),
                        subtitle: Text(
                          'الشيخ فقط يفتح الفيديو وينقل الدور',
                          style: cairo(size: 12),
                        ),
                        value: live.isSheikh,
                        onChanged: live.setSheikhMode,
                      ),
                      SwitchListTile(
                        title: Text(
                          'أريد القراءة (ارفع يدك)',
                          style: cairo(size: 15),
                        ),
                        value: live.handRaised,
                        onChanged: (_) => live.toggleHand(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (live.inSession)
                  GoldButton(
                    label: 'مغادرة المقرأة',
                    icon: Icons.call_end_rounded,
                    onPressed: _leave,
                  )
                else
                  GoldButton(
                    label: _joining ? 'جارٍ الاتصال…' : 'ادخل الغرفة الآن',
                    icon: Icons.mic_rounded,
                    onPressed: _joining ? null : _join,
                  ),
                const SizedBox(height: 10),
                Text(
                  'الصوت هو الأساس، والفيديو للشيخ فقط — ومن يطلب منه الشيخ',
                  textAlign: TextAlign.center,
                  style: cairo(
                    size: 13,
                    color: AppColors.mutedText(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheikhTile(BuildContext context, LiveController live) {
    final sheikh = live.sheikh;
    return AppCard(
      highlight: true,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.gold,
            child: Text(
              'ش',
              style: amiri(
                size: 28,
                bold: true,
                color: AppColors.deepGreen,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sheikh.name,
                  style: cairo(
                    size: 19,
                    weight: 800,
                    color: AppColors.text(context),
                  ),
                ),
                Text(
                  'شيخ المقرأة — فيديو مفتوح',
                  style: cairo(
                    size: 13,
                    color: AppColors.mutedText(context),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.videocam_rounded,
                  size: 16,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 4),
                Text(
                  'فيديو',
                  style: cairo(
                    size: 13,
                    weight: 800,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
