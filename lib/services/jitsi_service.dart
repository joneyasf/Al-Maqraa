import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants.dart';

/// الاتصال بغرفة المقرأة على Jitsi.
/// الصوت مفتوح افتراضيًا، والفيديو مغلق افتراضيًا ما عدا الشيخ.
/// إذا فشل الـ SDK لأي سبب، نفتح الغرفة في المتصفح/تطبيق Jitsi كبديل.
class JitsiService {
  final JitsiMeet _jitsiMeet = JitsiMeet();
  bool _joined = false;

  bool get isJoined => _joined;

  Future<bool> joinRoom({
    required String displayName,
    required bool videoOn,
  }) async {
    try {
      final options = JitsiMeetConferenceOptions(
        serverURL: kJitsiServerUrl,
        room: kJitsiRoomName,
        configOverrides: {
          'startWithAudioMuted': false,
          'startWithVideoMuted': !videoOn,
          'subject': 'المقرأة الليلية — لوجه الله',
          'prejoinPageEnabled': false,
        },
        featureFlags: {
          'chat.enabled': false,
          'invite.enabled': false,
          'raise-hand.enabled': true,
        },
        userInfo: JitsiMeetUserInfo(displayName: displayName, email: ''),
      );
      await _jitsiMeet.join(options);
      _joined = true;
      return true;
    } catch (_) {
      return _openInBrowser();
    }
  }

  Future<bool> _openInBrowser() async {
    try {
      final uri = Uri.parse(kJitsiRoomUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        _joined = true;
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<void> hangUp() async {
    try {
      await _jitsiMeet.hangUp();
    } catch (_) {}
    _joined = false;
  }
}
